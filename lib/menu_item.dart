import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MenuItem {
  final String name;
  final Icon icon;
  final Color backGroundColor;

  MenuItem({@required this.name, @required this.icon, @required this.backGroundColor});
}

final menuItemsList = [
  MenuItem(
    name: "Send Money",
    icon: Icon(
      Icons.attach_money,
      color: Colors.white,
    ),
    backGroundColor: Color(0xFFE91E63),
  ),
  MenuItem(
    name: "Receive money",
    icon: Icon(
      Icons.score,
      color: Colors.white,
    ),
    backGroundColor: Color(0xFFFF5722),
  ),
  MenuItem(
    name: "My Profile",
    icon: Icon(
      CupertinoIcons.profile_circled,
      color: Colors.white,
    ),
    backGroundColor: Color(0xFF4CAF50),
  ),
];
