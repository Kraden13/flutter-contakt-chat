import 'dart:convert';

import 'package:chat_contakt/global/environments.dart';
import 'package:chat_contakt/models/login_response.dart';
import 'package:chat_contakt/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _auth = false;
  final _storage = new FlutterSecureStorage();

  bool get auth => this._auth;

  set auth(bool valor) {
    this._auth = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.auth = true;
    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post('${Environments.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.auth = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.auth = true;
    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final resp = await http.post('${Environments.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.auth = false;
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      this.user = registerResponse.user;
      await this._saveToken(registerResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get('${Environments.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      this.user = registerResponse.user;
      await this._saveToken(registerResponse.token);
      return true;
    } else {
      this._logOut();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logOut() async {
    await _storage.delete(key: 'token');
  }
}
