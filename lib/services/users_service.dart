import 'package:http/http.dart' as http;
import 'package:chat_contakt/global/environments.dart';
import 'package:chat_contakt/models/user.dart';
import 'package:chat_contakt/services/auth_service.dart';
import 'package:chat_contakt/models/users_response.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final resp = await http.get('${Environments.apiUrl}/users', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
