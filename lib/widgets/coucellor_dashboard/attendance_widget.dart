import 'package:aelix/providers/attendance_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/student_list_provider.dart';
import 'dropdown_button.dart';

class AttendanceTable extends StatefulWidget {
  const AttendanceTable({Key? key}) : super(key: key);

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  var pin;
  String isActive = 'initial';
  bool showMedical = false;
  final _formKey = GlobalKey<FormState>();

  verifyPin(context) async {
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
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            message: "pin validation success",
            duration: const Duration(seconds: 3),
            leftBarIndicatorColor: Colors.green,
          ).show(context);
        });

        setState(() {
          showMedical = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<StudentList>(context).data;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.school),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Students',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              dataRowHeight: 110,
              columns: const [
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Attendance'),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Out of Class',
                      softWrap: true,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text('Medical'),
                ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              rows: studentData
                  .map<DataRow>((data) => DataRow(cells: [
                        DataCell(Text(data['name'] + ' ' + data['lastName'])),
                        if (data['dismiss'] != null)
                          const DataCell(Text('Dismissed')),
                        if (data['dismiss'] == null &&
                                data['attaindence']['attendence'] == null ||
                            data['attaindence']['attendence'] == 'null')
                          DataCell(Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    var attendObj = {"attendence": "1"};
                                    await Provider.of<Attendance>(context,
                                            listen: false)
                                        .updateAttendance(
                                            data['attaindence']['_id'],
                                            attendObj,
                                            'updateAttaindence');
                                    if (!mounted) return;
                                    var result = Provider.of<Attendance>(
                                            context,
                                            listen: false)
                                        .updatedAttendance;
                                    Provider.of<StudentList>(context,
                                            listen: false)
                                        .updateStudentList(data['_id'], result);
                                  },
                                  icon: const Icon(Icons.check),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.close),
                                  onPressed: () async {
                                    var attendObj = {"attendence": "0"};
                                    await Provider.of<Attendance>(context,
                                            listen: false)
                                        .updateAttendance(
                                            data['attaindence']['_id'],
                                            attendObj,
                                            'updateAttaindence');
                                    if (!mounted) return;
                                    var result = Provider.of<Attendance>(
                                            context,
                                            listen: false)
                                        .updatedAttendance;
                                    Provider.of<StudentList>(context,
                                            listen: false)
                                        .updateStudentList(data['_id'], result);
                                  },
                                ),
                              )
                            ],
                          )),
                        if (data['dismiss'] == null &&
                            data['attaindence']['attendence'] == '1' &&
                            data['attaindence']['attendence'] != 'null')
                          const DataCell(Text('present')),
                        if (data['dismiss'] == null &&
                            data['attaindence']['attendence'] == '0' &&
                            data['attaindence']['attendence'] != 'null')
                          const DataCell(Text('absent')),
                        DataCell(DropDownMenuButton(
                            data: data,
                            isdismissed: data['dismiss'] != null ||
                                    data['attaindence']['attendence'] == '0'
                                ? true
                                : false)),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function()) setState) {
                                    return !showMedical
                                        ? AlertDialog(
                                            title: const Text('Enter Your Pin'),
                                            content: Form(
                                              key: _formKey,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              child: TextFormField(
                                                maxLength: 4,
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
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
                                                  hintText: "Enter pin",
                                                  labelText: "Pin",
                                                ),
                                                onChanged: (value) {
                                                  pin = value;
                                                  setState(() {});
                                                },
                                                onFieldSubmitted: (_) => {
                                                  setState(() {
                                                    isActive = 'loading';
                                                  }),
                                                  verifyPin(context)
                                                },
                                              ),
                                            ),
                                            actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      verifyPin(context);
                                                    },
                                                    child: const Text('Submit'))
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
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.medical_information),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Medical')
                            ],
                          ),
                        )),
                        DataCell(TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          onPressed: () async {
                            if (data['dismiss'] != null) return;
                            if (data['attaindence']['attendence'] == '1' ||
                                data['attaindence']['attendence'] == '0') {
                              var attendObj = {"attendence": "null"};
                              await Provider.of<Attendance>(context,
                                      listen: false)
                                  .updateAttendance(data['attaindence']['_id'],
                                      attendObj, 'updateAttaindence');
                              if (!mounted) return;
                              var result = Provider.of<Attendance>(context,
                                      listen: false)
                                  .updatedAttendance;
                              Provider.of<StudentList>(context, listen: false)
                                  .updateStudentList(data['_id'], result);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'please mark attendance first')));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.edit_note),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Edit')
                            ],
                          ),
                        ))
                      ]))
                  .toList()),
        )
      ],
    );
  }
}
