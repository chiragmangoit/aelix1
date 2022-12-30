import 'dart:io';

import 'package:aelix/providers/attendance_provider.dart';
import 'package:aelix/providers/auth_provider.dart';
import 'package:aelix/providers/chat_provider.dart';
import 'package:aelix/providers/classes_provider.dart';
import 'package:aelix/providers/counsellor_provider.dart';
import 'package:aelix/providers/student_list_provider.dart';
import 'package:aelix/screens/class/class_page.dart';
import 'package:aelix/screens/dashboard/dashboard.dart';
import 'package:aelix/screens/login/login_page.dart';
import 'package:aelix/screens/manage_councellor/manage_councellor.dart';
import 'package:aelix/screens/manage_student/student_list.dart';
import 'package:aelix/screens/password/password.dart';
import 'package:aelix/screens/pin/change_pin.dart';
import 'package:aelix/screens/profile_page/profile_page.dart';
import 'package:aelix/widgets/chat/chatDetail.dart';
import 'package:aelix/widgets/chat/chatPage.dart';
import 'package:aelix/widgets/manage_councellor/add_councellor.dart';
import 'package:aelix/widgets/manage_students/add_student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  getToken() async {
    return await Auth.token;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(value: StudentList()),
        ChangeNotifierProvider.value(value: Attendance()),
        ChangeNotifierProvider.value(value: Counsellor()),
        ChangeNotifierProvider.value(value: Classes()),
        ChangeNotifierProvider.value(value: ChatProvider()),
      ],
      child: Consumer<Auth>(
        builder:
            (final BuildContext context, final profile, final Widget? child) {
          return MaterialApp(
            title: 'Aelix',
            // theme: ThemeData(
            //   primarySwatch: Colors.blue,
            // ),
            initialRoute: profile.isAuthenticated ? '/home' : '/',
            routes: {
              "/": (context) => const LoginPage(),
              "/home": (context) => const Dashboard(),
              "/profile": (context) => const Profile(),
              "/pin": (context) => const Pin(),
              "/password": (context) => const Password(),
              "/counsellor": (context) => const ManageCounsellor(),
              "/addCounsellor": (context) => const CounsellorForm(),
              "/class": (context) => const Class(),
              "/student": (context) => const StudentsInfo(),
              "/createStudent": (context) => CreateStudent(),
              "/chat": (context) => const ChatPage(),
              "/chatDetail": (context) => const ChatDetailPage(),
            },
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
