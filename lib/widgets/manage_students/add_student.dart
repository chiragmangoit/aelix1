import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/classes_provider.dart';
import '../../providers/student_list_provider.dart';
import '../profile/textWidget.dart';

class CreateStudent extends StatefulWidget {
  CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  Map? studentData = {};
  bool error = false;
  bool checkedValue = false;
  String? token = '';
  String? state = 'initial';
  bool isLoading = false;
  String _date = "Not set";
  var dob;
  var args;
  var selectedClass;
  late Timer timer = Timer(const Duration(milliseconds: 1), () {});

  List visibility = [
    'Visible to everyone',
    'Only visible to group',
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    studentData = {};
    timer.cancel();
  }

  final _formKey = GlobalKey<FormState>();

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  loadOldData() {
    args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      setState(() {
        studentData = args as Map;
        _date = studentData!['DOB'];
        dob = studentData!['DOB'];
        studentData!['Ename'] = studentData!['emergency'][0]['Ename'];
        studentData!['number'] = studentData!['emergency'][0]['number'];
        selectedClass = studentData!['assignClass']['_id'];
      });
    }
  }

  addStudent() async {
    var result = await Provider.of<StudentList>(context, listen: false)
        .addStudent(studentData, _imageFile);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "student added successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => {
            setState(() {
              String url = "https://api-aelix.mangoitsol.com/api/student";
              Provider.of<StudentList>(context, listen: false)
                  .fetchStudent(url);
            }),
            Navigator.pop(context)
          });
    }
  }

  updateStudent(id) async {
    var result = await Provider.of<StudentList>(context, listen: false)
        .updateStudent(studentData, _imageFile, id);
    if (!mounted) return;
    print(result);
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "student updated successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => {
        setState(() {
          String url = "https://api-aelix.mangoitsol.com/api/student";
          Provider.of<StudentList>(context, listen: false)
              .fetchStudent(url);
        }),
        Navigator.pop(context)});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    loadOldData();
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ${response.exception!.code}');
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(File(_imageFile!.path)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return Text(
        error ? 'You have not yet picked an image.' : 'pick an image',
        textAlign: TextAlign.center,
        style:
            TextStyle(color: error ? Colors.red : Colors.black, fontSize: 16),
      );
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      if (File(pickedFile!.path).lengthSync() < 6000) {
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        if (!mounted) return;
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: "image should be below 6kb",
          duration: const Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red,
        ).show(context);
      }
    } catch (e) {
      print("Image picker error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var classList = Provider.of<Classes>(context).allClass;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
        ),
        body: Padding(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    args == null ? 'Add Student' : 'Update Student',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'First Name',
                    text: studentData!['name'] ?? '',
                    hintText: 'Enter First Name',
                    onChanged: (value) {
                      setState(
                        () {
                          studentData!['name'] = value;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: 'Last Name',
                    text: studentData!['lastName'] ?? '',
                    hintText: 'enter lastname',
                    onChanged: (value) {
                      studentData!['lastName'] = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: "Father's Name",
                    text: studentData!['fatherName'] ?? '',
                    hintText: 'enter fatherName',
                    onChanged: (value) {
                      studentData!['fatherName'] = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "D-O-B",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          theme: const DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        print('confirm $date');
                        _date = '${date.year} - ${date.month} - ${date.day}';
                        setState(() {
                          var f = DateFormat('E, d MMM yyyy HH:mm:ss');
                          dob =
                              "${f.format(DateTime.now().toUtc())} GMT+0530 (India Standard Time)";
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.date_range,
                                      size: 18.0,
                                    ),
                                    Text(
                                      " $_date",
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Text(
                            "Pick",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    label: "Address",
                    text: studentData!['address'] ?? '',
                    hintText: 'enter address',
                    onChanged: (value) {
                      studentData!['address'] = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Emergency",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFieldWidget(
                    label: '',
                    text: studentData!['Ename'] ?? '',
                    hintText: 'enter name',
                    onChanged: (value) {
                      studentData!['Ename'] = value;
                    },
                  ),
                  TextFieldWidget(
                    type: TextInputType.phone,
                    label: "",
                    text: studentData!['number'] != null
                        ? studentData!['number'].toString()
                        : '',
                    hintText: 'enter number',
                    onChanged: (value) {
                      studentData!['number'] = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Class",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField(
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
                          studentData!['assignClass'] = val;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    validator: true,
                    label: "Medical(optional)",
                    text: studentData!['medical'] ?? '',
                    hintText: 'enter medical info',
                    onChanged: (value) {
                      studentData!['medical'] = value;
                    },
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Image",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (studentData!['image'] == null &&
                      studentData!['image'] == '')
                    FutureBuilder<void>(
                      future: retriveLostData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.done:
                            return _previewImage();
                          default:
                            return const Text('Picked an image');
                        }
                      },
                    ),
                  if (studentData!['image'] != null &&
                      studentData!['image'] != '')
                    Image.network(studentData!['image']),
                  ElevatedButton(
                    onPressed: _pickImage,
// tooltip: 'Pick Image from gallery',
                    child: const Text('upload image'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _date.isNotEmpty) {
                              studentData!['DOB'] = dob;
                              if (args == null) {
                                studentData!['emergency'] = jsonEncode([
                                  {
                                    studentData!['Ename']:
                                        studentData!['number']
                                  },
                                  {"mother": studentData!['number']},
                                  {"sister": studentData!['number']}
                                ]);
                                addStudent();
                              } else {
                                studentData!['assignClass'] = selectedClass;
                                studentData!['emergency'] = jsonEncode([
                                  {
                                    'Ename': studentData!['Ename'],
                                    'number': studentData!['number']
                                  },
                                  {
                                    'Ename': "mother",
                                    'number': studentData!['number']
                                  },
                                  {
                                    'Ename': "sister",
                                    'number': studentData!['number']
                                  },
                                ]);
                                updateStudent(studentData!['_id']);
                              }
                              setState(() {
                                isLoading = true;
                              });
// uploadImage(newsData);
                            } else if (_date.isNotEmpty) {
                              setState(() {
                                error = true;
                              });
                            }
                          },
                          child: studentData == null
                              ? const Text('create')
                              : const Text('update')),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('cancel'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
