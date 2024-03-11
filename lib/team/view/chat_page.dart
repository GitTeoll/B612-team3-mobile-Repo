import 'package:b612_project_team3/common/secure_storage/secure_storage.dart';
import 'package:b612_project_team3/firebase/service/database_service.dart';
import 'package:b612_project_team3/team/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ChatPage extends StatefulWidget {
  static String get routeName => 'chatpage';
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String adminName = "temp";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        adminName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
              onPressed: () {
                final Map<String, String> groupDetails = {
                  'groupId': widget.groupId,
                  'groupName': widget.groupName,
                  'adminName': adminName,
                };
                context.push('/groupinfo', extra: groupDetails);
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          //여기에 채팅 메세지가 존재합니다.
          chatMessages(),
          GestureDetector(
            onTap: () {
              sendMessages();
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: "메세지를 입력하세요.",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              //메세지가 있는 경우
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]['sender']);
                  },
                  itemCount: snapshot.data.docs.length,
                )
              //메세지가 없는 경우
              : Container();
        });
  }

  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
