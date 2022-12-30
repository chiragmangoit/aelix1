import 'package:aelix/widgets/coucellor_dashboard/timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/attendance_provider.dart';
import '../../providers/student_list_provider.dart';

class DropDownMenuButton extends StatefulWidget {
  final data;
  final isdismissed;
  const DropDownMenuButton({Key? key, this.data, this.isdismissed}) : super(key: key);

  @override
  State<DropDownMenuButton> createState() => _DropDownMenuButtonState();
}

class _DropDownMenuButtonState extends State<DropDownMenuButton> {
  List outOfClassOptions = ['No', 'In Rest Room', 'In Front Office', 'In Camp'];
  var selectedOption = 'No';

  updateStatus(data) async {
    var attendObj = {"out_of_class": selectedOption};
    await Provider.of<Attendance>(context, listen: false).updateAttendance(
        data['_id'], attendObj, 'updateStatus');
    if (!mounted) return;
    var result =
        Provider.of<Attendance>(context, listen: false).updatedAttendance;
    Provider.of<StudentList>(context, listen: false)
        .updateStudentList(data['_id'], result);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isdismissed);
    return Column(
      children: [
        IgnorePointer(
          ignoring: widget.isdismissed,
          child: DropdownButton(
            value: selectedOption,
            focusColor: Colors.black,
            isExpanded: true,
            iconSize: 30.0,
            style: const TextStyle(color: Colors.black),
            items: outOfClassOptions.map<DropdownMenuItem<String>>(
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
                  selectedOption = val!;
                  updateStatus(widget.data);
                },
              );
            },
          ),
        ),
        if (selectedOption != 'No') const NewStopWatch()
      ],
    );
  }
}
