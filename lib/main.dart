import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_contakt/pages/login_page.dart';
import 'package:chat_contakt/routes/routes.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:chat_contakt/services/chat_service.dart';
import 'package:chat_contakt/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
