import 'package:flutter/material.dart';

import '../../providers/keys.dart';

import '../../widgets/profile/profile_page.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text('My Profile'),
      ),
      body: const Scaffold(
          body: ProfileInfo()),
    );
  }
}
