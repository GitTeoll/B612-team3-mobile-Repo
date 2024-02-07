import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color? appBarBackGroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool drawerEnableOpenDragGesture;
  final double? appBarHeight;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.appBarBackGroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.drawerEnableOpenDragGesture = false,
    this.appBarHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 224, 239, 240),
      appBar: renderAppBar(),
      drawer: drawer,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor:
            appBarBackGroundColor ?? const Color.fromARGB(255, 224, 239, 240),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: appBarHeight,
        title: Text(
          title!,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
