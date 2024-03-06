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
      "recentMesseage": "",
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
}
