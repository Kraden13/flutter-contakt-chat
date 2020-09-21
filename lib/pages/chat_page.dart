import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: Column(
          children: [
            Header(),
          ],
        ));
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Column(children: [
      Image(image: AssetImage('assets/tag-logo.png')),
      Text('Contakt Chat')
    ])));
  }
}
