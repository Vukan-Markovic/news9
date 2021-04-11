import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';

class NavigationScreen extends StatefulWidget {
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  //Todo Replace the Containers with the screens when created
  final List<Widget> _pageOptions = [
    Container(child: Text("Global news")),
    Container(child: Text("Recommended news")),
    Container(child: Text("Favorite news")),
    Container(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter News9"),
        backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
      ),
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(Icons.home_rounded)
                  : Icon(Icons.home_outlined),
              label: 'Global',
              backgroundColor: HexColor.fromHex(ColorConstants.primaryColor)),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Icon(Icons.star_rounded)
                : Icon(Icons.star_border_rounded),
            label: 'Recommended',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? Icon(Icons.bookmark_rounded)
                : Icon(Icons.bookmark_border_rounded),
            label: 'Favorite',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? Icon(Icons.person_rounded)
                : Icon(Icons.person_outline_rounded),
            label: 'Profile',
            backgroundColor: HexColor.fromHex(ColorConstants.primaryColor),
          ),
        ],
        onTap: setCurrentIndex,
      ),
    );
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}