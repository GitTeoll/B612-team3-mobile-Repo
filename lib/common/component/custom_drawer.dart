import 'package:flutter/material.dart';

// 좌측 상단 메뉴 추가
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "디자인 확정 X",
            ),
          ),
          ListTile(
            title: Text('메뉴 항목1'),
          )
        ],
      ),
    );
  }
}
