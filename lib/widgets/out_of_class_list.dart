import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../model/common_model.dart';
import '../providers/student_list_provider.dart';

class OutOfClassList extends StatefulWidget {
  const OutOfClassList({Key? key}) : super(key: key);

  @override
  State<OutOfClassList> createState() => _OutOfClassListState();
}

class _OutOfClassListState extends State<OutOfClassList> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<StudentList>(context);
    final studentsList = data.outOfClassStudennt;
    if (studentsList.length != 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: studentsList.length,
                itemBuilder: (context, index) {
                  final studentCatalog = studentsList[index];
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      child: Student(
                        studentCatalog: studentCatalog,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Center(child: Text("No record Found")),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class Student extends StatelessWidget {
  final studentCatalog;

  const Student({Key? key, required this.studentCatalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (studentCatalog['image'] != null)
            CircleAvatar(
              backgroundImage: NetworkImage(studentCatalog['image']),
            ),
          if (studentCatalog['image'] == null)
            CircleAvatar(
              backgroundColor: Colors.grey[400],
              child: Text(studentCatalog['name'][0]),
            ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(studentCatalog['name'] + ' ' + studentCatalog['lastName'])
            ],
          )
        ],
      ),
    );
  }
}
