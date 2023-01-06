import 'package:aelix/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceSearchBar extends StatelessWidget {
  final selectedClass;
  final date;
  const AttendanceSearchBar(String this.selectedClass, this.date, {Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        flex: 1,
        child: TextField(
          onChanged: (value) {
            date['searchName'] = value;
            Provider.of<Attendance>(context, listen: false).fetchAttendance(selectedClass, date);
          },
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromRGBO(188, 188, 188, 1))
              ),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
              prefixIcon: Container(
                padding: const EdgeInsets.all(15),
                width: 18,
                child: const Icon(Icons.search),
              )),
        ),
      )
    ]);
  }
}
