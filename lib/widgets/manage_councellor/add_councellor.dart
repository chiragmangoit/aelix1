import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/auth_provider.dart';
import '../../providers/counsellor_provider.dart';
import '../profile/textWidget.dart';

class CounsellorForm extends StatefulWidget {
  const CounsellorForm({Key? key}) : super(key: key);

  @override
  State<CounsellorForm> createState() => _CounsellorFormState();
}

class _CounsellorFormState extends State<CounsellorForm> {
  final _formKey = GlobalKey<FormState>();
  var selectedClass;
  var classList;
  var _isInit = true;
  var args;
  Map? updatedData = {"role": "counsellor"};
  Map? newUserData = {"role": "counsellor"};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClasses();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    if (_isInit) {
      args = ModalRoute.of(context)!.settings.arguments;
      if (args != null) {
        setState(() {
          newUserData = args as Map?;
          selectedClass = newUserData!['classId']['_id'];
        });
      }
    }
    _isInit = false;
  }

  updateCounsellor(id, data) async {
    var result = await Provider.of<Counsellor>(context, listen: false)
        .updateCounsellor(id, data);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "counsellor updated successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => Navigator.pop(context));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Please enter unique username",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    }
  }

  fetchClasses() async {
    String url = "https://api-aelix.mangoitsol.com/api/getClass";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    setState(() {
      classList = decodedData['data'];
    });
  }

  createCounsellor(data) async {
    var result = await Provider.of<Counsellor>(context, listen: false)
        .addCounsellor(data);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "counsellor added successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => Navigator.pop(context));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Please enter unique username",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: classList != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Counsellor',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'First Name',
                        text: newUserData!['name'] ?? '',
                        onChanged: (name) {
                          newUserData!['name'] = name;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'Last Name',
                        text: newUserData!['lastname'] ?? '',
                        onChanged: (lastname) {
                          newUserData!['lastname'] = lastname;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        type: TextInputType.number,
                        label: 'Mobile Number',
                        text: newUserData!['phone'] != null
                            ? newUserData!['phone'].toString()
                            : '',
                        onChanged: (phone) {
                          newUserData!['phone'] = phone;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Assign Class',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 7),
                      DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        hint: const Text('Assign class',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        value: selectedClass,
                        focusColor: Colors.black,
                        isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.black),
                        items: classList.map<DropdownMenuItem<String>>(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val['_id'],
                              child: Text(val['className']),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              selectedClass = val!;
                              newUserData!['classId'] = val!;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'User Name',
                        text: newUserData!['username'] ?? '',
                        onChanged: (username) {
                          newUserData!['username'] = username;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (args == null)
                        TextFieldWidget(
                          label: 'Password',
                          text: newUserData!['password'] ?? '',
                          onChanged: (password) {
                            newUserData!['password'] = password;
                          },
                        ),
                      if (args == null) const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () => {
                                    if (_formKey.currentState!.validate())
                                      {
                                        if (args == null)
                                          {createCounsellor(newUserData)}
                                        else
                                          {
                                            updatedData!['name'] = newUserData!['name'],
                                            updatedData!['lastname'] = newUserData!['lastname'],
                                            updatedData!['phone'] = newUserData!['phone'].toString(),
                                            updatedData!['classId'] = selectedClass,
                                            updatedData!['username'] =  newUserData!['username'],
                                            updatedData!['password'] =  "123456",
                                            updateCounsellor(
                                                newUserData!['_id'],
                                                updatedData)
                                          }
                                      }
                                  },
                              child: Text(
                                args == null ? 'Create' : 'Update',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                          ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const CircularProgressIndicator().centered(),
    );
  }
}
