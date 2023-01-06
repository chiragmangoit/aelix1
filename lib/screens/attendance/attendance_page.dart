import 'package:flutter/material.dart';

import '../../widgets/attendance_report/attendance_report.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  AttendancePageState createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          title: const Text('Attendance Report'),
        ),
        body: const AttendanceReport());
  }
}
