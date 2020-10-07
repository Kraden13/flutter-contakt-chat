import 'package:chat_contakt/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_contakt/models/user.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List users = [
    User(
        uid: '1',
        name: 'Cristian',
        email: 'cristian.lancharro.2@gmail.com',
        online: true),
    User(uid: '2', name: 'Dani', email: 'rodiaz.music@gmail.com', online: true),
    User(uid: '3', name: 'Tobal', email: 'tobal@gmail.com', online: false),
  ];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            }),
        actions: [Icon(Icons.check_circle)],
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
    );
  }

  void _loadUsers() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
