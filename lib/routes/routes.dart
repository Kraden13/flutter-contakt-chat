import 'package:chat_contakt/pages/chat_page.dart';
import 'package:chat_contakt/pages/loading_page.dart';
import 'package:chat_contakt/pages/login_page.dart';
import 'package:chat_contakt/pages/register_page.dart';
import 'package:chat_contakt/pages/users_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
