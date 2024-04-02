import 'package:flutter/material.dart';

abstract class BottomNavigationPage {
  String getTitle(BuildContext context);
  Icon getIcon();
}
