import 'package:chat_contakt/models/messages_response.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:chat_contakt/services/chat_service.dart';
import 'package:chat_contakt/services/socket_service.dart';
import 'package:chat_contakt/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chat_contakt/widgets/header.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool isWritting = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('private-message', _listenMessage);
    _loadMessages(this.chatService.userTo.uid);
  }

  void _loadMessages(String userId) async {
    List<Message> chat = await this.chatService.getChat(userId);
    final history = chat.map((m) => new ChatMessage(
          uid: m.from,
          text: m.message,
          animationController: new AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload['message'],
      uid: payload['from '],
      animationController: AnimationController(
          duration: Duration(milliseconds: 300), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(
                  chatService.userTo.name.substring(0, 2),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                backgroundColor: Color(0xffAAEA61),
                maxRadius: 14,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                chatService.userTo.name,
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) => _messages[i])),
            Divider(
              height: 1,
            ),
            Container(color: Colors.white, child: _inputChat())
          ],
        )));
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handledSubmit,
            onChanged: (String text) {
              setState(() {
                if (text.trim().length > 0) {
                  isWritting = true;
                } else {
                  isWritting = false;
                }
              });
            },
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            focusNode: _focusNode,
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: (Platform.isIOS)
                ? CupertinoButton(child: Text('Enviar'), onPressed: () {})
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Color(0xffAAEA61)),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: (isWritting)
                              ? () =>
                                  _handledSubmit(_textController.text.trim())
                              : null),
                    )),
          ),
        ],
      ),
    ));
  }

  _handledSubmit(String text) {
    if (text.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      animationController: new AnimationController(
          duration: Duration(milliseconds: 200), vsync: this),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      isWritting = false;
    });
    this.socketService.emit('private-message', {
      'from': this.authService.user.uid,
      'to': this.chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('private-message');
    super.dispose();
  }
}
