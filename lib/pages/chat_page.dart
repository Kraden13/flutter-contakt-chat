import 'package:chat_contakt/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chat_contakt/widgets/header.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool isWritting = false;
  final List<ChatMessage> _messages = [];
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
                  'CR',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                backgroundColor: Color(0xffAAEA61),
                maxRadius: 14,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Cristian Lancharro',
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
      uid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      isWritting = false;
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
