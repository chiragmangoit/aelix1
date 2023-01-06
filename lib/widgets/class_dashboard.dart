import 'dart:convert';

import 'package:aelix/providers/student_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/auth_provider.dart';

class ClassDashboard extends StatefulWidget {
  const ClassDashboard({Key? key}) : super(key: key);

  @override
  State<ClassDashboard> createState() => _ClassDashboardState();
}

class _ClassDashboardState extends State<ClassDashboard> {
  var filterOptions;
  var selectedFilter = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClasses();
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
    selectedFilter =  Provider.of<StudentList>(context, listen: false)
        .classType;
    final studentData = Provider.of<StudentList>(context).data;
    return studentData != null
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (Auth.role == 'counsellor')
                    Text( studentData.length == 0 ? 'Today Attendance' :
                      'Today Attendance for class ${studentData[0]['assignClass']['className']}',
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  if (Auth.role != 'counsellor')
                    Row(
                      children: [
                         Text(
                          'FILTER BY:',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(19, 15, 38, 1)
                          ),
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
                                textStyle: Theme.of(context).textTheme.headlineMedium,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(19, 15, 38, 1)
                            ),
                            items: filterOptions?.map<DropdownMenuItem<String>>(
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
                                Provider.of<StudentList>(context, listen: false)
                                    .allStudentData;
                              } else {
                                Provider.of<StudentList>(context, listen: false)
                                    .filterStudentByClass(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(229, 233, 242, 1)),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Total Students',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              studentData.length.toString(),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(229, 233, 242, 1)),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Present Students',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              Provider.of<StudentList>(context)
                                  .presentStudent
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(229, 233, 242, 1)),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Absent Students',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              Provider.of<StudentList>(context)
                                  .absentStudent
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(229, 233, 242, 1)),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Out of Class',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              Provider.of<StudentList>(context)
                                  .outOfClassStudennt
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        : const CircularProgressIndicator().centered();
  }
}
