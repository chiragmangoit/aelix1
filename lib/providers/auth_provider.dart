import 'dart:async';
import 'dart:convert';

import 'package:aelix/model/common_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  static String? _token;
  static String? _role;
  static String? _userId;
  static var _userName;

  bool get isAuthenticated {
    autoLogIn();
    return _token != null;
  }

  logOut() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static get user async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString('userData');
    var result = json.decode(res!);
    return result;
  }

  static get token async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getString('userData');
    if (res == null) return null;
    var result = json.decode(res!);
    _token = result['token'];
    return _token;
  }

  static String? get role {
    return _role;
  }

  static String? get userid {
    return _userId;
  }

  static String? get userInfo {
    return _userName;
  }

  autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!);
    _token = extractedUserData['token'] as String?;
    _userId = extractedUserData['_id'] as String?;
    notifyListeners();
    return true;
  }

  Future signInWithEmail(String username, String password) async {
    String url = 'https://api-aelix.mangoitsol.com/api/login';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.persistentConnection = false;
    request.fields['username'] = username;
    request.fields['password'] = password;
    num? resStatus;
    await request
        .send()
        .then((result) async {
          resStatus = result.statusCode;
          await http.Response.fromStream(result).then((response) async {
            if (kDebugMode) {
              print('response.body ${response.body}');
            }
            var responseData = json.decode(response.body);
            CommonModel.userData = responseData;
            _userName = responseData['lastname'] != null
                ? responseData['name'] + responseData['lastname']
                : responseData['name'];
            _token = responseData['token'];
            _role = responseData['role'];
            _userId = responseData['_id'];
            // _autoLogout();
            notifyListeners();
            final prefs = await SharedPreferences.getInstance();
            final userData = response.body;
            prefs.setString('userData', userData);
          });
        })
        .catchError((err) => print('error : $err'))
        .whenComplete(() {});
    return resStatus;
  }
}
