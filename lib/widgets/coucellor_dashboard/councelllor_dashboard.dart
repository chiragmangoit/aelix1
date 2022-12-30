import 'package:aelix/providers/classes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/keys.dart';
import '../../providers/student_list_provider.dart';
import '../../widgets/drawer.dart';
import '../appbar.dart';
import '../class_dashboard.dart';
import 'attendance_widget.dart';

class CouncellorDashboard extends StatelessWidget {
  const CouncellorDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<StudentList>(context).data);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Scaffold(
          key: scaffoldKey,
          drawer: const SafeArea(child: MyDrawer()),
          body: Provider.of<StudentList>(context).data != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.38,
                            child: const ClassDashboard()),
                        const SizedBox(
                          height: 10,
                        ),
                        const AttendanceTable()
                      ],
                    ),
                  ),
                )
              : const CircularProgressIndicator().centered()),
    );
  }
}
