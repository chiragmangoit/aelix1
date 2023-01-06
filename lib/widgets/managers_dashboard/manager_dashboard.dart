import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/classes_provider.dart';
import '../../providers/student_list_provider.dart';
import '../absent_list.dart';
import '../class_dashboard.dart';
import '../out_of_class_list.dart';

class ManagersDashboardContent extends StatefulWidget {
  const ManagersDashboardContent({Key? key}) : super(key: key);

  @override
  State<ManagersDashboardContent> createState() =>
      _ManagersDashboardContentState();
}

class _ManagersDashboardContentState extends State<ManagersDashboardContent> {
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String url = "https://api-aelix.mangoitsol.com/api/student";
      Provider.of<StudentList>(context).fetchStudent(url);
      Provider.of<Classes>(context).fetchClasses();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<StudentList>(context).data != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.39,
                      child: const ClassDashboard()),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: const Color.fromRGBO(244, 244, 244, 1)),
                            height: 50,
                            child: const TabBar(
                                labelColor: Color.fromRGBO(0, 92, 179, 1),
                                unselectedLabelColor: Color.fromRGBO(165, 165, 165, 1),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color: Color.fromRGBO(229, 233, 242, 1)),
                                tabs: [
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Absent",
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Out of Class",
                                      ),
                                    ),
                                  ),
                                ])),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TabBarView(
                              children: [AbsentList(), OutOfClassList()],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const CircularProgressIndicator().centered();
  }
}
