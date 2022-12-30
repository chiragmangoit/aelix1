import 'package:aelix/model/common_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../providers/keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  logOut(context) async {
    final profile = Provider.of<Auth>(context, listen: false);
    profile.isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  @override
  Widget build(BuildContext context) {
    var img = CommonModel.userData['image'];
    return AppBar(
      title: SvgPicture.network(
        "https://aelix.mangoitsol.com/static/media/aelix-logo.fa5be6ee4f133e417cf57892724df96c.svg",
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width * 0.2,
      ),
      actions: [
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/prof.jpg'),
            ),
            offset: Offset(0, AppBar().preferredSize.height),
            itemBuilder: (context) {
              return [
                // const PopupMenuItem<int>(
                //   value: 0,
                //   child: Text("Manage Profile"),
                // ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Logout"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
              } else if (value == 1) {
                logOut(context);
                Navigator.of(context).pushReplacementNamed('/');
              }
            }),
      ],
      // bottom: PreferredSize(
      //     preferredSize: preferredSize,
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Container(
      //             decoration: BoxDecoration(
      //               color: Colors.red,
      //               border: Border.all(width: 0.1, color: Colors.transparent),
      //               borderRadius: const BorderRadius.all(Radius.circular(30)),
      //             ),
      //             child: IconButton(
      //               padding: const EdgeInsets.all(0),
      //               color: Colors.white,
      //               onPressed: () {},
      //               icon: const Icon(Icons.alarm),
      //               style: IconButton.styleFrom(
      //                   elevation: 5.0,
      //                   foregroundColor: Colors.white,
      //                   backgroundColor: Colors.red),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               color: Colors.yellow,
      //               border: Border.all(width: 0.1, color: Colors.transparent),
      //               borderRadius: const BorderRadius.all(Radius.circular(30)),
      //             ),
      //             child: IconButton(
      //               color: Colors.white,
      //               onPressed: () {},
      //               icon: const Icon(Icons.alarm),
      //               style: IconButton.styleFrom(
      //                   elevation: 5.0,
      //                   foregroundColor: Colors.white,
      //                   backgroundColor: Colors.red),
      //             ),
      //           ),
      //           Container(
      //             decoration: BoxDecoration(
      //               color: Colors.black,
      //               border: Border.all(width: 0.1, color: Colors.transparent),
      //               borderRadius: const BorderRadius.all(Radius.circular(30)),
      //             ),
      //             child: IconButton(
      //               color: Colors.white,
      //               onPressed: () {},
      //               icon: const Icon(Icons.alarm),
      //               style: IconButton.styleFrom(
      //                   elevation: 5.0,
      //                   foregroundColor: Colors.white,
      //                   backgroundColor: Colors.red),
      //             ),
      //           )
      //         ],
      //       ),
      //     )),
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.blue),
      leading: IconButton(
        onPressed: () {
          //on drawer menu pressed
          if (scaffoldKey.currentState != null) {
            if (scaffoldKey.currentState!.isDrawerOpen == false) {
              scaffoldKey.currentState!.openDrawer();
            } else {
              scaffoldKey.currentState!.openEndDrawer();
            }
          }
          // if (scaffoldKeyProfile.currentState != null) {
          //   if (scaffoldKeyProfile.currentState!.isDrawerOpen == false) {
          //     scaffoldKeyProfile.currentState!.openDrawer();
          //   } else {
          //     scaffoldKeyProfile.currentState!.openEndDrawer();
          //   }
          // }
          // if (scaffoldKeyPin.currentState != null) {
          //   if (scaffoldKeyPin.currentState!.isDrawerOpen == false) {
          //     scaffoldKeyPin.currentState!.openDrawer();
          //   } else {
          //     scaffoldKeyPin.currentState!.openEndDrawer();
          //   }
          // }
          // if (scaffoldKeyPassword.currentState != null) {
          //   if (scaffoldKeyPassword.currentState!.isDrawerOpen == false) {
          //     scaffoldKeyPassword.currentState!.openDrawer();
          //   } else {
          //     scaffoldKeyPassword.currentState!.openEndDrawer();
          //   }
          // }
        },
        icon: const Icon(Icons.menu),
      ),
    );
  }
}
