import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_list_provider.dart';

class SearchBar extends StatelessWidget {
  // final Function(String) change;

  const SearchBar({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
        Flexible(
        flex: 1,
        child: TextField(
            onChanged: (value) {
              Provider.of<StudentList>(context, listen: false).allStudentData;
              Provider.of<StudentList>(context, listen: false).searchStudent(value);
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
