import 'package:b612_project_team3/firebase/service/database_service.dart';
import 'package:b612_project_team3/team/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  static String get routeName => 'searchpage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  Future<String> userName = DatabaseService().getUserFullName();
  User? user = FirebaseAuth.instance.currentUser;
  bool isJoined = false;
  String groupName = "";

  String getAdminName(String name) {
    return name.substring(
      name.indexOf("_") + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.cyan,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.cyan,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      hintText: "Search Groups...",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              groupName = searchSnapshot!.docs[index]['groupName'];
              return GroupTile(
                userName,
                searchSnapshot!.docs[index]['groupID'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinedOrNot(Future<String> userName, String groupId, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget GroupTile(
      Future<String> userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, admin);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.cyan,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('Admin = ${getAdminName(admin)}'),
      trailing: InkWell(
        onTap: () async {
          DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              //가입한경우 => 탈퇴, 가입하지 않은경우 => 가입
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.red, "$groupName 그룹탈퇴에 성공했습니다.");

            Future.delayed(const Duration(seconds: 2), () {
              //Go Router를 이용한 페이지 이동
            });
          } else {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.green, "그룹에 성공적으로 가입했습니다.");
          }
        },
        child: isJoined
            ? Container(
                width: 100, // 이 부분에 width 값을 추가합니다.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: const Center(
                  child: Text(
                    "가입함",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Container(
                width: 100, // 이 부분에 width 값을 추가합니다.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.cyan,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: const Center(
                  child: Text(
                    "가입",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void showSnackBar(BuildContext context, Color color, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
