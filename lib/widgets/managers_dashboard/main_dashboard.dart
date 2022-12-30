import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/classes_provider.dart';
import '../../providers/keys.dart';
import '../../providers/student_list_provider.dart';
import '../../widgets/drawer.dart';
import '../absent_list.dart';
import '../appbar.dart';
import '../class_dashboard.dart';
import '../out_of_class_list.dart';

class ManagersDashboard extends StatefulWidget {
  const ManagersDashboard({Key? key}) : super(key: key);

  @override
  State<ManagersDashboard> createState() => _ManagersDashboardState();
}

class _ManagersDashboardState extends State<ManagersDashboard> {
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Classes>(context).fetchClasses();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                              height: MediaQuery.of(context).size.height * 0.39,
                              // : MediaQuery.of(context).size.height * 0.46,
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
                                            width: 0,
                                            color: Colors.transparent),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.blueAccent),
                                    // color: Colors.blue,
                                    height: 50,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: TabBar(
                                          labelColor: Colors.blueAccent,
                                          unselectedLabelColor: Colors.white,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          indicator: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  topRight: Radius.circular(5)),
                                              color: Colors.white),
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
                                          ]),
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TabBarView(
                                      children: [
                                        AbsentList(),
                                        OutOfClassList()
                                      ],
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
                : const CircularProgressIndicator().centered()),
      ),
    );
  }
}
