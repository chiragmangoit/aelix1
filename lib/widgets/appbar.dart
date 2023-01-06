import 'package:aelix/model/common_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../providers/auth_provider.dart';
import '../providers/keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  showAlert(context,message,colorStyle) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
       return AlertDialog(
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.dangerous,size: 48,),
                  const Text('Are You Sure?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Do you really want to '),
                      Text('Code $message', style: TextStyle(
                        color: colorStyle,
                        fontWeight: FontWeight.bold
                      ),textAlign: TextAlign.center,),
                      const Text(' ?')
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text('ok'))
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var img = CommonModel.userData['image'];
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(width: 0, color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              color: Colors.white,
              onPressed: () {
                showAlert(context, 'Red', Colors.red);
              },
              icon: const Icon(Icons.alarm),
              style: IconButton.styleFrom(
                  elevation: 5.0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(width: 0, color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                showAlert(context, 'Yellow', Colors.yellow);
              },
              icon: const Icon(Icons.alarm),
              style: IconButton.styleFrom(
                  elevation: 5.0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 0, color: Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                showAlert(context, 'Black', Colors.black);
              },
              icon: const Icon(Icons.alarm),
              style: IconButton.styleFrom(
                  elevation: 5.0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
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
                Provider.of<Auth>(context, listen: false).logOut();
                Navigator.of(context).pushReplacementNamed('/');
              }
            }),
      ],
      backgroundColor: const Color.fromRGBO(245, 245, 245, 0),
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
        },
        icon: Image.asset('assets/images/drawericon.png')
      ),
    );
  }
}
