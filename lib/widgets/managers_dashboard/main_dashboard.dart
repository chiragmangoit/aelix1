import 'package:aelix/providers/bottom_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/keys.dart';
import '../appbar.dart';
import '../bottomDrawer.dart';
import '../drawer.dart';

class ManagersDashboard extends StatefulWidget {
  const ManagersDashboard({Key? key}) : super(key: key);

  @override
  State<ManagersDashboard> createState() => _ManagersDashboardState();
}

class _ManagersDashboardState extends State<ManagersDashboard> {

  @override
  Widget build(BuildContext context) {
    var bodyValue = Provider.of<NavProvider>(context).bodyContent;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Scaffold(
          key: scaffoldKey,
          drawer: const SafeArea(child: MyDrawer()),
          body: bodyValue,
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
