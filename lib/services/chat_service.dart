import 'package:chat_contakt/models/messages_response.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_contakt/global/environments.dart';
import 'package:chat_contakt/models/user.dart';

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Message>> getChat(String userID) async {
    final resp = await http.get('${Environments.apiUrl}/messages/$userID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final messagesResp = messagesResponseFromJson(resp.body);

    return messagesResp.messages;
  }
}
