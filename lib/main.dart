import 'package:flutter/material.dart';
import 'package:chat_contakt/routes/routes.dart';
import 'package:chat_contakt/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
