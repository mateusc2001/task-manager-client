import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  const ResponsiveLayout(this.mobileLayout, this.desktopLayout);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constranits) {
      if (constranits.maxWidth < 600) {
        return mobileLayout;
      } else {
        return desktopLayout;
      }
    });
  }
}
