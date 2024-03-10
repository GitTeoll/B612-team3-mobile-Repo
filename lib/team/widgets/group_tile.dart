import 'package:b612_project_team3/team/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 여러 값을 Map으로 그룹화하여 전달
        final Map<String, String> chatDetails = {
          'groupId': widget.groupId,
          'groupName': widget.groupName,
          'userName': widget.userName,
        };

        context.push('/chat', extra: chatDetails);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(255, 224, 239, 240),
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "탭하여 ${widget.userName}(으)로 입장하세요.",
          ),
        ),
      ),
    );
  }
}
