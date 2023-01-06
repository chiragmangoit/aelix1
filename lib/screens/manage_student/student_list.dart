import 'package:flutter/material.dart';

import '../../widgets/manage_students/manage_student.dart';

class StudentsInfo extends StatelessWidget {
  const StudentsInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text('Manage Student'),
      ),
      body: const Scaffold(
          body: ManageStudent()),
    );
  }
}
