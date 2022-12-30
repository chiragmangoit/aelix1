import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/auth_provider.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var oldPassword;
  var newPassword;
  var confirmPassword;

  updatePassword() async {
    var data = {
      "confirmPassword": confirmPassword,
      "newPassword": newPassword,
      "oldPassword": oldPassword,
      "id": Auth.userid
    };
    String url = "https://api-aelix.mangoitsol.com/api/resetPassword";
    var token = Auth.token;
    final response = await http.post(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    }, body: data);
    if(!mounted) return;
    if (response.statusCode == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: "Password updated successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: "old password is incorrect",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.pin_rounded),
                Text(
                  "Manage Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24,),
                    const Text('Old Password',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "Enter old password",
                        labelText: "Old Password",
                      ),
                      onChanged: (value) {
                        oldPassword = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24,),
                    const Text('New Password',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "enter new password",
                        labelText: "New Password",
                      ),
                      onChanged: (value) {
                        newPassword = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24,),
                    const Text('Confirm Password',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm Password';
                        } else if(newPassword != confirmPassword) {
                          return 'confirm Password not matched';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "confirm Password",
                        labelText: "Confirm Password",
                      ),
                      onChanged: (value) {
                        confirmPassword = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                        const SizedBox(width: 40,),
                        ElevatedButton(onPressed: () =>
                        {
                          if(_formKey.currentState!.validate()) {
                            updatePassword(),
                          }
                        }, child: const Text('Update'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
