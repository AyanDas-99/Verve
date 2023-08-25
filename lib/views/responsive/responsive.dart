import 'package:flutter/material.dart';

class Responsive {
  static const _smallPhone = 375;
  static const _phone = 450;
  static const _tab = 800;
  static const _desktop = 1024;
  static const _largeDesktop = 1440;

  static bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < _phone;

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < _smallPhone;

  static bool isTab(BuildContext context) =>
      MediaQuery.of(context).size.width < _tab &&
      MediaQuery.of(context).size.width > _phone;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > _tab;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > _desktop;
}
