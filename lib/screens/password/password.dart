import 'package:flutter/material.dart';

import '../../providers/keys.dart';
import '../../widgets/appbar.dart';
import '../../widgets/change_password.dart';
import '../../widgets/drawer.dart';

class Password extends StatelessWidget {
  const Password({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Scaffold(
          key: scaffoldKeyPassword,
          body: const ChangePassword()),
    );
  }
}
