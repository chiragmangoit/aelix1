import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_nav_bar_provider.dart';


class BottomNavBar extends StatefulWidget {
  // final onItemTapped;

  BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  _onItemTapped(int index) {
    setState(() {
      Provider.of<NavProvider>(context,listen: false).setNewIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: Provider.of<NavProvider>(context).index,
      //New
      onTap: _onItemTapped,
      selectedIconTheme: const IconThemeData(color: Colors.grey, size: 40),
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      showSelectedLabels: false,
      showUnselectedLabels: true,
      unselectedItemColor: Colors.black,
      selectedItemColor: const Color.fromRGBO(0, 92, 179, 1),
      elevation: 0.0,
      items: const [
        BottomNavigationBarItem(
          label: 'chat',
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'pin',
          icon: Icon(
            Icons.password,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'home',
          icon: Icon(
            Icons.home_rounded,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'account',
          icon: Icon(
            Icons.account_circle_outlined,
            size: 35,
          ),
        ),
        BottomNavigationBarItem(
          label: 'password',
          icon: Icon(
            Icons.lock_outlined,
            size: 35,
          ),
        ),
      ],
    );
  }
}