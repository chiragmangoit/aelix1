import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/common_model.dart';
import '../providers/keys.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            leading: const Icon(
              CupertinoIcons.home,
              color: Colors.black,
            ),
            title: Text(
              "Dashboard",
              textScaleFactor: 1.2,
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
            onTap: () => {Navigator.pop(context)},
          ),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
                leading: const Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  color: Colors.black,
                ),
                title: Text(
                  "My Profile",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
                onTap: () =>
                    {toggleDrawer(), Navigator.pushNamed(context, '/profile')}),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
              leading: const Icon(
                Icons.school,
                color: Colors.black,
              ),
              title: Text(
                "Students",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              onTap: () =>
                  {toggleDrawer(), Navigator.pushNamed(context, '/student')},
            ),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
              leading: const Icon(
                Icons.add_card_outlined,
                color: Colors.black,
              ),
              title: Text(
                "Counsellor",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              onTap: () =>
                  {toggleDrawer(), Navigator.pushNamed(context, '/counsellor')},
            ),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
              leading: const Icon(
                Icons.password,
                color: Colors.black,
              ),
              title: Text(
                "Pin",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              onTap: () =>
                  {toggleDrawer(), Navigator.pushNamed(context, '/pin')},
            ),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
              leading: const Icon(
                CupertinoIcons.lock,
                color: Colors.black,
              ),
              title: Text(
                "Change Password",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              onTap: () =>
                  {toggleDrawer(), Navigator.pushNamed(context, '/password')},
            ),
          ListTile(
            leading: const Icon(
              Icons.message,
              color: Colors.black,
            ),
            title: Text(
              "Chat",
              textScaleFactor: 1.2,
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
            onTap: () {
              toggleDrawer();
              Navigator.pushNamed(context, '/chat');
            },
          ),
          if (CommonModel.userData['role'] != 'counsellor')
            ListTile(
              leading: const Icon(
                Icons.class_,
                color: Colors.black,
              ),
              title: Text(
                "Manage Class",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              onTap: () =>
                  {toggleDrawer(), Navigator.pushNamed(context, '/class')},
            ),
        ],
      ),
    );
  }
}

toggleDrawer() async {
  if (scaffoldKey.currentState!.isDrawerOpen) {
    scaffoldKey.currentState!.openEndDrawer();
  } else {
    scaffoldKey.currentState!.openDrawer();
  }
}

// void doRoute(BuildContext context, String name) {
//   print(ModalRoute.of(context)?.settings.name == name);
//   if (!_currentRoute.contains(name)) {
//     _currentRoute.add(name);
//     Navigator.pushNamed(context, name);
//   } else {
//     if (ModalRoute.of(context)?.settings.name != name) {
//       Navigator.popUntil(context, ModalRoute.withName(name));
//     } else {
//       Navigator.pop(context);
//     }
//   }
//   // _currentRoute = name;
// }
