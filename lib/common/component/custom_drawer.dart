import 'package:flutter/material.dart';

// 좌측 상단 메뉴 추가
// TODO : 로그인, 비로그인시 메뉴 내의 내용이 바뀌어야 할 듯
// ex) 비로그인 : "로그인, 회원가입", 로그인 : "계정정보"
// router 상 이동하는 위치도 바뀌어야 함
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
