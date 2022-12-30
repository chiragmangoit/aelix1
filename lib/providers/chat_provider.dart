import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';

class ChatProvider with ChangeNotifier {
  var messages;
  var users = [];

  fetchUsers() async {
    users = [];
    var id = Auth.userid;
    String url = "https://api-aelix.mangoitsol.com/api/allGroup/$id?searchkey=";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    for (var data in decodedData) {
      for (var innerData in data) {
        users.add(innerData);
      }
    }
    notifyListeners();
  }

  fetchMessages(id) async {
    String url = "https://api-aelix.mangoitsol.com/api/getMessage/$id";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    messages = decodedData;
    notifyListeners();
  }

  accessChat(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/accessChat";
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    return decodedData;
  }

  sendMessage(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/sendMessage";
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    final catalogJson = response.body;
    // print(catalogJson);
    final decodedData = jsonDecode(catalogJson);
    messages = decodedData;
    notifyListeners();
    return decodedData;
  }

  get userMessages {
    return messages;
  }

  get allUsers {
    return users;
  }


  getNewMessage(msg) {
    messages = msg;
    notifyListeners();
  }
}
