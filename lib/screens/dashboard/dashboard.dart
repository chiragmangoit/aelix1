import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/common_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_list_provider.dart';
import '../../widgets/coucellor_dashboard/councelllor_dashboard.dart';
import '../../widgets/managers_dashboard/main_dashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _isInit = true;
  var role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkLogin();
  }

  // checkLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //    var resData = prefs.getString('userData');
  //    res = jsonDecode(resData!);
  //   });
  // }

  @override
  Future<void> didChangeDependencies() async {
    var user = await Auth.user;
    role = user['role'];
    print(role);
    String url;
    if (role == 'counsellor') {
      url = "https://api-aelix.mangoitsol.com/api/getStu/${Auth.userid}";
    } else {
      url = "https://api-aelix.mangoitsol.com/api/student";
    }
    if(!mounted) return;
    if (_isInit) {
      Provider.of<StudentList>(context,listen: false).fetchStudent(url);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: role != null || Auth.role != 'counsellor'
          ? const ManagersDashboard()
          : const CouncellorDashboard(),
    );
  }
}
