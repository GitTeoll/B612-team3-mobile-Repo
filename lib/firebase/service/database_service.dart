import 'package:b612_project_team3/team/view/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //if collection dont exist => create , already exist => load
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid ": uid,
    });
  }

  //사용자 정보 불러오기
  getUserGroups() async {
    print("uid1 = $uid");
    return userCollection.doc(uid).snapshots();
  }

  //그룹 생성하기

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupdocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin":
          "${id}_$userName", // userName이 겹칠 수 도 있으므로 설정함. 중복되지 않는다면 userName으로 설정
      "members": [],
      "groupID": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    //멤버정보 업데이트

    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion([
        "${uid}_$userName", //kakao:uid_lang0311의 형태
      ]),
      "groupID": groupdocumentReference.id,
    });

    DocumentReference userDocumenrReference = userCollection.doc(uid);
    return userDocumenrReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupName"])
    });
  }

  // 사용자의 fullName 불러오기
  Future<String> getUserFullName() async {
    DocumentSnapshot userDocument = await userCollection.doc(uid).get();
    Map<String, dynamic>? userData =
        userDocument.data() as Map<String, dynamic>?;
    return userData!['fullName'];
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();

    return documentSnapshot['admin'];
  }

  getGroupMembers(GroupId) async {
    return groupCollection.doc(GroupId).snapshots();
  }

  //검색
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //그룹에 존재하는지 bool값 반환
  Future<bool> isUserJoined(
      String groupName, String groupID, Future<String> userName) async {
    DocumentReference userDocumenrReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumenrReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupID}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  //그룹 가입 나가기 버튼 기능 구현
  Future toggleGroupJoin(
      String groupId, Future<String> userName, String groupName) async {
    DocumentReference userDocumenrReference = userCollection.doc(uid);
    DocumentReference groupdocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumenrReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumenrReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await userDocumenrReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumenrReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await userDocumenrReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  //메세지 보내기
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection('messages').add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
