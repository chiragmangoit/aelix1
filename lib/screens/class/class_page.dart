import 'package:flutter/material.dart';

import '../../widgets/manage_class/manage_class.dart';

class Class  extends StatelessWidget {
  const Class ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text('Manage Class'),
      ),
      body: const Scaffold(
          body: ManageClass()),
    );
  }
}
