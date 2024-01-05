import 'package:b612_project_team3/common/view/root_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}
