import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aelix/providers/classes_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/auth_provider.dart';
import '../../providers/student_list_provider.dart';
import '../progressLoader.dart';
import '../search_bar.dart';

class ManageStudent extends StatefulWidget {
  const ManageStudent({Key? key}) : super(key: key);

  @override
  State<ManageStudent> createState() => _ManageStudentState();
}

class _ManageStudentState extends State<ManageStudent> {
  var pin;
  var _doesChange = true;
  String isActive = 'initial';
  bool showMedical = false;
  final _formKey = GlobalKey<FormState>();
  HashSet selectItems = HashSet();
  bool isMultiSelectionEnabled = false;
  bool inProgress = false;
  List? csvList;
  List csvFileContentList = [];
  List csvModuleList = [];
  var filterOptions;
  var selectedFilter = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClasses();
  }

  verifyPin() async {
    if (_formKey.currentState!.validate()) {
      String url = 'https://api-aelix.mangoitsol.com/api/varifyPin';
      var token = await Auth.token;
      final response = await http.post(Uri.parse(url), headers: {
        'authorization': 'Bearer $token',
      }, body: {
        'pin': pin
      });
      if (response.statusCode != 200) {
        if (!mounted) return;
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: "please enter valid pin",
          duration: const Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red,
        ).show(context);
      }
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          showMedical = true;
        });
      }
    }
  }

  deleteStudent(id) async {
    var result = await Provider.of<StudentList>(context, listen: false)
        .deleteStudent(id);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "student deleted successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
      setState(() {
        _doesChange = true;
      });
    }
  }

  dismissStudent(data) async {
    var result = await Provider.of<StudentList>(context, listen: false)
        .dismissStudent(data);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "student dismissed",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
      setState(() {
        selectItems.clear();
        _doesChange = true;
      });
    }
  }

  loadCsvFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
      withData: true,
    );
    var selectedCSVFile = result?.files.first;
    selectParseCSV(selectedCSVFile);
  }

  selectParseCSV(selectedCSVFile) async {
//Optional for CSV Validation
    String csvFileHeaderRowColumnTitles =
        '"assignClass","name","lastName","fatherName","DOB","address","medical","emergency_name_1","emergency_num_1","emergency_name_2","emergency_num_2","emergency_name_3","emergency_num_3","image"';

    try {
      String s = String.fromCharCodes(selectedCSVFile.bytes);
      // Get the UTF8 decode as a Uint8List
      var outputAsUint8List = Uint8List.fromList(s.codeUnits);
      // split the Uint8List by newline characters to get the csv file rows
      csvFileContentList = utf8.decode(outputAsUint8List).split('\n');
      print('Selected CSV File contents: ');
      print(csvFileContentList);

      // Check the column titles and sequence - is the CSV file in the correct template format?
      if (csvFileContentList[0].toString().trim().hashCode !=
          csvFileHeaderRowColumnTitles.hashCode) {
        // CSV file is not in correct format
        print('CSV file does not seem to have a valid format');
        return 'Error: The CSV file does not seem to have a valid format.';
      }

// check if CSV file has any content - content length > 0?
      if (csvFileContentList.length == 0 || csvFileContentList[1].length == 0) {
        // CSV file does not have content
        print('CSV file has no content');
        return 'Error: The CSV file has no content.';
      }
      // CSV file seems to have a valid format
      print(
          'CSV file has a valid format and has contents, hence proceed to parse...');

// Current First row of the CSV file has column headers - remove it
      csvFileContentList.removeAt(0);
      // print('Selected CSV File contents after removing the Column Headers: ');

// Remove Duplicate Rows from the CSV File
      csvList = csvFileContentList.toSet().toList();
      // print('CSV file contents after deduplication / removal of duplicates');
      //CSV Files in Array
      // print(csvList);

//Array to class module
      csvList?.forEach((csvRow) {
        if (csvRow != null && csvRow.trim().isNotEmpty) {
          // current row has content and is not null or empty
          var row = csvRow.split(',');
          if (row[0][1] != '"') {
            var studentData = {
              "assignClass": jsonDecode(row[0]),
              "name": jsonDecode(row[1]),
              "lastName": jsonDecode(row[2]),
              "fatherName": jsonDecode(row[3]),
              "DOB": jsonDecode(row[4]),
              "address": jsonDecode(row[5]),
              "medical": jsonDecode(row[6]),
              "emergency_name_1": jsonDecode(row[7]),
              "emergency_num_1": jsonDecode(row[8]),
              "emergency_name_2": jsonDecode(row[9]),
              "emergency_num_2": jsonDecode(row[10]),
              "emergency_name_3": jsonDecode(row[11]),
              "emergency_num_3": jsonDecode(row[12]),
              "image": jsonDecode(row[13])
            };
            csvModuleList.add(studentData);
          }
        }
      });
      setState(() {
        inProgress = true;
      });
      uploadCsv();
    } catch (e) {
      print(e.toString());

      return 'Error: $e';
    }
  }

  uploadCsv() async {
    var data = jsonEncode({"array": csvModuleList});
    var result =
        await Provider.of<StudentList>(context, listen: false).uploadCsv(data);
    if (!mounted) return;
    if (result == 200) {
      setState(() {
        _doesChange = true;
      });
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Csv Uploaded successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => setState(() {
            inProgress = false;
            csvModuleList = [];
          }));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Check Csv Format",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context).then((value) => setState(() {
            inProgress = false;
          }));
    }
  }

  assignClass(classData) async {
    var data = jsonEncode(classData);
    var result =
        await Provider.of<Classes>(context, listen: false).assignClass(data);
    if (!mounted) return;
    if (result == 200) {
      setState(() {
        _doesChange = true;
      });
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Class assigned successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => {
            setState(() {
              String url = "https://api-aelix.mangoitsol.com/api/student";
              Provider.of<StudentList>(context, listen: false)
                  .fetchStudent(url);
              selectItems.clear();
            }),
            Navigator.pop(context)
          });
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Unknown Error Occurred",
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
    List classes = ['All'];
    for (var data in decodedData['data']) {
      classes.add(data['className'].toString());
    }
    setState(() {
      filterOptions = classes;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedFilter = Provider.of<StudentList>(context, listen: false).classType;
    var studentData = Provider.of<StudentList>(context).data;
    return studentData != null
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.school),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Students',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'FILTER BY:',
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(19, 15, 38, 1)),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: DropdownButton(
                              underline: const SizedBox(),
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                              value: selectedFilter,
                              focusColor: Colors.black,
                              isExpanded: true,
                              iconSize: 30.0,
                              style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(19, 15, 38, 1)),
                              items:
                                  filterOptions?.map<DropdownMenuItem<String>>(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(
                                  () {
                                    selectedFilter = val!;
                                  },
                                );
                                Provider.of<StudentList>(context, listen: false)
                                    .classValue = val;
                                if (val == 'All') {
                                  Provider.of<StudentList>(context,
                                          listen: false)
                                      .allStudentData;
                                } else {
                                  Provider.of<StudentList>(context,
                                          listen: false)
                                      .filterStudentByClass(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SearchBar(
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          selectedFilter,
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 92, 179, 1)),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _doesChange = true;
                                });
                                Navigator.pushNamed(context, '/createStudent');
                              },
                              child: const Text(
                                'Add Student',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return !inProgress
                                            ? AlertDialog(
                                                title: const Text(
                                                    'Upload students record in CSV'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/Shape.png'),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed:
                                                              loadCsvFromStorage,
                                                          child: const Text(
                                                              'Upload CSV')),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : AlertDialog(
                                                content: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  child: const FittedBox(
                                                      child:
                                                          CircularProgressIndicatorApp()),
                                                ),
                                              );
                                      },
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Bulk Upload',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ))
                        ],
                      )
                    ],
                  ),
                  if (studentData.length == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Center(
                        child: Text('No record Found'),
                      ),
                    ),
                  Column(
                      children: studentData
                          .map<Widget>((data) => Stack(children: [
                                Card(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (data['image'] != null &&
                                            data['image'].contains('https'))
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(data['image']),
                                          ),
                                        if (data['image'] == null)
                                          CircleAvatar(
                                            backgroundColor: Colors.grey[400],
                                            child: Text(data['name'][0]),
                                          ),
                                        if (data['image'] != null &&
                                            !data['image'].contains('https'))
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "https://api-aelix.mangoitsol.com/${data['image']}"),
                                          ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Text(
                                                "${data['name']} ${data['lastName']} s/o ${data['fatherName']} ${data['lastName']}",
                                                style: GoogleFonts.poppins(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromRGBO(
                                                        25, 40, 56, 1)),
                                              ),
                                            ),
                                            // Text(data['assignClass']['className']),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    minimumSize:
                                                        Size.zero, // Set this
                                                    padding: EdgeInsets
                                                        .zero, // and this
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _doesChange = true;
                                                    });
                                                    Navigator.pushNamed(context,
                                                        '/createStudent',
                                                        arguments: data);
                                                  },
                                                  child: Text('Edit',
                                                      style: GoogleFonts.poppins(
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color
                                                                  .fromRGBO(119,
                                                              119, 119, 1))),
                                                ),
                                                const Text('  |  '),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize:
                                                        Size.zero, // Set this
                                                    padding: EdgeInsets
                                                        .zero, // and this
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              void Function(
                                                                      void
                                                                          Function())
                                                                  setState) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Emergency Number'),
                                                              content: SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.1,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: data[
                                                                          'emergency']
                                                                      .map<Widget>(
                                                                          (value) =>
                                                                              Text('${value['Ename']}: ${value['number']}'))
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Emergency No',
                                                      style: GoogleFonts.poppins(
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineMedium,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color
                                                                  .fromRGBO(119,
                                                              119, 119, 1))),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        IconButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black),
                                          onPressed: () {
                                            deleteStudent([data['_id']]);
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_outlined,
                                            color: Color.fromRGBO(
                                                121, 121, 121, 1),
                                          ),
                                        ),
                                        IconButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.black),
                                          onPressed: () {
                                            if (data['dismiss'] != null) {
                                              Flushbar(
                                                flushbarPosition:
                                                    FlushbarPosition.TOP,
                                                messageSize: 20,
                                                message:
                                                    "student already dismissed",
                                                duration:
                                                    const Duration(seconds: 3),
                                                leftBarIndicatorColor:
                                                    Colors.red,
                                              ).show(context);
                                            } else {
                                              dismissStudent(jsonEncode({
                                                "id": [data['_id']],
                                                "time": DateFormat('hh:mm:ss a')
                                                    .format(DateTime.now())
                                              }));
                                            }
                                          },
                                          icon: Image.asset(
                                              'assets/images/Vector.jpg'),
                                        ),
                                      ]),
                                ),
                                Positioned(
                                    bottom: 58,
                                    right: 0,
                                    child: IconButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  void Function(void Function())
                                                      setState) {
                                                return !showMedical
                                                    ? AlertDialog(
                                                        title: const Text(
                                                            'Enter Your Pin'),
                                                        content: Form(
                                                          key: _formKey,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          child: TextFormField(
                                                            maxLength: 4,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter Pin';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              hintText:
                                                                  "Enter pin",
                                                              labelText: "Pin",
                                                            ),
                                                            onChanged: (value) {
                                                              pin = value;
                                                              setState(() {});
                                                            },
                                                            onFieldSubmitted:
                                                                (_) => {
                                                              setState(() {
                                                                isActive =
                                                                    'loading';
                                                              }),
                                                              verifyPin()
                                                            },
                                                          ),
                                                        ),
                                                        actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancel')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  verifyPin();
                                                                },
                                                                child: const Text(
                                                                    'Submit'))
                                                          ])
                                                    : AlertDialog(
                                                        title: Text(
                                                            'Student Name: ${data['name']} ${data['lastName']}'),
                                                        content: Text(
                                                            'Medical message: ${data['medical']}'),
                                                      );
                                              },
                                            );
                                          },
                                        ).then((value) => setState(() {
                                              showMedical = false;
                                            }));
                                      },
                                      icon: Image.asset(
                                          'assets/images/health.png'),
                                    )),
                              ]))
                          .toList()),
                ],
              ),
            ),
          )
        : const CircularProgressIndicator().centered();
  }
}
