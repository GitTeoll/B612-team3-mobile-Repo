import 'package:b612_project_team3/firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupInfo extends StatefulWidget {
  static String get routeName => 'groupinfo';
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  late Future<String> userName;
  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    initUserName();
    super.initState();
  }

  void initUserName() {
    // 현재 로그인한 사용자의 UID를 사용하여 DatabaseService 인스턴스를 생성
    var dbService =
        DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid);
    userName = dbService.getUserFullName(); // 인스턴스를 통해 getUserFullName에 접근
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getAdminName(String name) {
    return name.substring(
      name.indexOf("_") + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.cyan,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            //탈퇴시 홈페이지로 이동
            onPressed: () async {
              DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .toggleGroupJoin(widget.groupId, userName, widget.groupName)
                  .whenComplete(() {
                context.go('/');
              });
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.cyan,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group : ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text('Admin : ${getAdminName(widget.adminName)}'),
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  Widget memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["members"] != null &&
                snapshot.data["members"].length > 0) {
              return ListView.builder(
                itemCount: snapshot.data["members"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String initial = getInitials(snapshot.data['members'][index]);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.cyan,
                        child: Text(
                          initial.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        getAdminName(snapshot.data['members'][index]),
                      ),
                      // subtitle: Text(getId()),
                    ),
                  );
                },
              );
            } else {
              // 리스트가 비어 있거나 null일 경우
              return const Center(
                child: Text("No members found."),
              );
            }
          } else {
            // 데이터 로딩 중
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  String getInitials(String name) {
    // 이름의 첫 글자를 추출합니다.
    return name.isNotEmpty
        ? name.substring(name.indexOf("_") + 1, name.indexOf("_") + 2)
        : '?';
  }
}
