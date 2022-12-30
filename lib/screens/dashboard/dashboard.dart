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
  var res;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
     var resData = prefs.getString('userData');
     res = jsonDecode(resData!);
    });
    print(res['role']);
  }

  @override
  void didChangeDependencies() {
    String url;
    if (CommonModel.userData['role'] == 'counsellor') {
      url = "https://api-aelix.mangoitsol.com/api/getStu/${Auth.userid}";
    } else {
      url = "https://api-aelix.mangoitsol.com/api/student";
    }
    if (_isInit) {
      Provider.of<StudentList>(context).fetchStudent(url);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _isInit = false;
    });
    return Scaffold(
      body: CommonModel.userData['role'] != 'counsellor'
          ? const ManagersDashboard()
          : const CouncellorDashboard(),
    );
  }
}
