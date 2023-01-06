import 'package:flutter/material.dart';

import '../../widgets/manage_councellor/edit_councellor.dart';

class ManageCounsellor extends StatelessWidget {
  const ManageCounsellor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text('Manage Counsellor'),
      ),
      body: const Scaffold(
          body: EditCounsellor()),
    );
  }
}
