import 'dart:async';

import 'package:aelix/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }

  redirect() {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    print(Auth.userInfo);
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          // width: double.infinity,
          // height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/images/welcome.png')),
              Text(
                "Welcome ${Auth.userInfo!}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    fontSize: 28),
              )
            ],
          ),
        ),
      ),
    );
  }
}
