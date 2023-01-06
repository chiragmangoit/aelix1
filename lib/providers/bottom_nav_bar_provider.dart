import 'dart:convert';

import 'package:aelix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../widgets/change_password.dart';
import '../widgets/change_pin.dart';
import '../widgets/chat/chat_list_page.dart';
import '../widgets/managers_dashboard/manager_dashboard.dart';
import '../widgets/profile/profile_page.dart';

class NavProvider with ChangeNotifier {

  static const List<Widget> pages = <Widget>[
    ChatListPage(),
    ChangePin(),
    ManagersDashboardContent(),
    ProfileInfo(),
    ChangePassword()
  ];
  int _index = 2;

  get bodyContent {
    return pages[_index];
  }

  get index {
    return _index;
  }

  setNewIndex(value) {
    _index = value;
    notifyListeners();
  }
}
