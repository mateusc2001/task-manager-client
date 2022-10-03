import 'package:flutter/material.dart';
import 'package:task_manager/screen/responsive/app-bar/desktop_appbar.dart';
import 'package:task_manager/screen/responsive/app-bar/mobile_appbar.dart';

class CustomAppBar extends StatelessWidget {
  final Widget mobileLayout = MobileAppBar();
  final Widget desktopLayout = DesktopAppBar();

  CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (builder, constranits) {
        if (constranits.maxWidth < 600) {
          return mobileLayout;
        } else {
          return desktopLayout;
        }
      }),
    );
  }
}
