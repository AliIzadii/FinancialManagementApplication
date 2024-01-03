import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:financial_management_app/screens/home_screen.dart';
import 'package:financial_management_app/screens/info_screen.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int curIndex = 0;
  Widget body = homeScreen();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [Icons.home, Icons.info],
          inactiveColor: Colors.black54,
          elevation: 0,
          gapLocation: GapLocation.center,
          borderWidth: 20,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          activeIndex: curIndex,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                body = homeScreen();
              } else {
                body = infoScreen();
              }
              curIndex = index;
            });
          },
        ),
        body: body,
      ),
    );
  }
}
