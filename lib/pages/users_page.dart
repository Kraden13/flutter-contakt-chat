import 'package:chat_contakt/services/chat_service.dart';
import 'package:chat_contakt/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_contakt/models/user.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:chat_contakt/services/socket_service.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final userService = new UsersService();
  List<User> users = [];
  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.name,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            }),
        actions: [
          (socketService.serverStatus == ServerStatus.Online)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.check_circle, color: Colors.green),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
                )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.lightGreen[400],
          ),
          waterDropColor: Colors.lightGreen[400],
        ),
        onRefresh: _loadUsers,
        child: _usersListView(),
      ),
    );
  }

  ListView _usersListView() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) => _userListTile(users[i]),
        separatorBuilder: (context, i) => Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(
          user.name.substring(0, 2),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightGreen[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (user.online) ? Colors.green[300] : Colors.red),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _loadUsers() async {
    // monitor network fetch

    this.users = await userService.getUsers();
    setState(() {});

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
