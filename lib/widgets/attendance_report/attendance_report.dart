import 'dart:io';

import 'package:aelix/widgets/attendance_report/expansionPanel.dart';
import 'package:aelix/widgets/attendance_report/searchbar_attendance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../providers/attendance_provider.dart';
import '../../providers/classes_provider.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  var selectedClass = '6262730b5f0f8244e6759fdc';
  var lastDayOfMonth;
  var date;
  bool _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Classes>(context).fetchClasses();
      var now = DateTime(DateTime.now().year, DateTime.now().month, 1);
      lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
      setState(
        () {
          date = {
            "fromDate": DateFormat('yyyy-MM-dd').format(now).toString(),
            "toDate": DateFormat('yyyy-MM-dd')
                .format(DateTime(
                    DateTime.now().year, DateTime.now().month, lastDayOfMonth))
                .toString()
          };
          Provider.of<Attendance>(context, listen: false)
              .fetchAttendance(selectedClass, date);
        },
      );
      Provider.of<Attendance>(context, listen: false)
          .fetchAttendance(selectedClass, date);
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

//   Future<void> _createPDF() async {
//     var data = Provider.of<Attendance>(context, listen: false).records;
//     _requestWritePermission();
//     //Create a new PDF document
//     final directory = await getApplicationSupportDirectory();
//     PdfDocument document = PdfDocument();
//
//     //Create a PdfGrid
//     PdfGrid grid = PdfGrid();
//
// //Add the columns to the grid
//     grid.columns.add(count: lastDayOfMonth + 1);
//
//
// //Add header to the grid
//     grid.headers.add(1);
//     PdfGridRow header = grid.headers[0];
//     header.cells[0].value = 'Student Name';
//
//     for (var index = 1; index <= lastDayOfMonth; index++) {
//       //Add the rows to the grid
//       header.cells[index].value = DateFormat.yMMMMd().format(
//           DateTime(DateTime.now().year, DateTime.now().month, index));
//     }
//
// //Add rows to grid
//     PdfGridRow row = grid.rows.add();
//     row.cells[0].value = '1';
//     row.cells[1].value = 'Arya';
//     row.cells[2].value = '6';
//     row = grid.rows.add();
//     row.cells[0].value = '12';
//     row.cells[1].value = 'John';
//     row.cells[2].value = '9';
//     row = grid.rows.add();
//     row.cells[0].value = '42';
//     row.cells[1].value = 'Tony';
//     row.cells[2].value = '8';
//
// //Draw grid to the page of the PDF document
//     grid.draw(
//         page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
//
//     //Get directory path
//     final path = directory.path;
//     File file = File('$path/Output.pdf');
//
// //Saves the document
//     await file.writeAsBytes(await document.save());
//
//     //Get external storage directory
//
// //Open the PDF document in mobile
//     OpenFile.open('$path/Output.pdf');
//
//     //Dispose the document
//     document.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    var classes = Provider.of<Classes>(context).classesData;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(width: 10,),
          AttendanceSearchBar(selectedClass, date),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'FILTER BY:',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(19, 15, 38, 1)),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: DropdownButton(
                  underline: const SizedBox(),
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.25,
                  focusColor: Colors.black,
                  isExpanded: true,
                  value: selectedClass,
                  iconSize: 30.0,
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(19, 15, 38, 1)),
                  items: classes?.map<DropdownMenuItem<String>>(
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
                        Provider.of<Attendance>(context, listen: false)
                            .fetchAttendance(selectedClass, date);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pie_chart_outline,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Attendance Report',
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(12, 12, 12, 1)),
                    )
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: [
                          const Icon(
                            Icons.download_for_offline,
                            color: Colors.red,
                            size: 16,
                          ),
                          Text(
                            'Download',
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(4, 4, 4, 1)),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const ExpansionItem(),
        ],
      ),
    );
  }
}
