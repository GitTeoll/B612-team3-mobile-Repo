import 'package:b612_project_team3/common/component/search_box.dart';
import 'package:b612_project_team3/common/const/colors.dart';
import 'package:b612_project_team3/firebase/service/database_service.dart';
import 'package:b612_project_team3/team/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

void _handleSearchChanged(String value) {
  // 여기에서 사용자의 입력값을 처리합니다. 예: 콘솔에 출력
  print("검색어: $value");
}

class _TeamScreenState extends State<TeamScreen> {
  Stream? groups;
  String groupName = "";
  bool _createIsLoading = false;

  // getUserResult() async{
  //   var result = await FirebaseFirestore.instance.collection("usrs").doc(FirebaseAuth.instance.currentUser!.uid).get();
  //   return result.data();
  // }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //stream 의 snapshots를 불러옵니다
  gettingUserData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  //String manipulation (groupId_groupName)의 형태에서 manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 224, 239, 240),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Community",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: const SearchBox(
              onChanged: _handleSearchChanged,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          groupList(),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () => popUpDialogue(context)),
    );
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          //조건문에서 조건 학인

          //데이터가 존재하는경우
          if (snapshot.hasData) {
            //그 데이터가 NULL값이 아닌경우
            if (snapshot.data['groups'] != null) {
              //데이터가 존재하고 null값도 아니며 길이가 0이 아닌경우 (성공)
              if (snapshot.data['groups'].length != 0) {
                return Flexible(
                  child: ListView.builder(
                      itemCount: snapshot.data['groups'].length,
                      itemBuilder: (context, index) {
                        //최근 생성 그룹이 위로 향하게 하는 index 값
                        int reverseIndex =
                            snapshot.data['groups'].length - index - 1;
                        return GroupTile(
                            userName: snapshot.data['fullName'],
                            groupId:
                                getId(snapshot.data['groups'][reverseIndex]),
                            groupName:
                                getName(snapshot.data['groups'][reverseIndex]));
                      }),
                );
              }
              //데이터가 존재하고 null도 아니지만 길이가 0인경우(존재하지 않음)
              else {
                return noGroupWidget();
              }
            }
            //존재하지만 null인경우
            else {
              return noGroupWidget();
            }
            //데이터가 존재하지 않는 경우(실패)
          } else {
            print("uid = ${FirebaseAuth.instance.currentUser!.uid}");
            print('snapshot.hasdata = ${snapshot.hasData}');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  popUpDialogue(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: const Text("그룹 생성하기"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _createIsLoading == true
                      ? const Center(child: CircularProgressIndicator())
                      : TextField(
                          onChanged: (value) {
                            groupName = value;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("취소")),
                ElevatedButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() {
                          _createIsLoading = true;
                        });

                        // DatabaseService 인스턴스 생성
                        DatabaseService dbService = DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid);

                        // 비동기적으로 사용자 이름을 불러오기
                        String userName = await dbService.getUserFullName();

                        //아래 코드 안되면 await dbService.createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName); 이렇게 해볼 것
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          _createIsLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackbar(context, "그룹이 성공적으로 생성되었습니다.");
                      }
                    },
                    child: const Text("생성")),
              ],
            );
          }),
        );
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialogue(context);
            },
            child: const Icon(
              Icons.add_circle,
              color: Colors.grey,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text("현재 가입한 그룹 및 채팅방이 없습니다."),
          const Text('버튼을 눌러 그룹을 생성하거나 그룹을 검색해보세요.'),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
