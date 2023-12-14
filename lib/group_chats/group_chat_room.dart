
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import 'group_info.dart';

class GroupChatRoom extends StatelessWidget {
  final String groupChatId, groupName;

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // void onSendMessage() async {
  //   if (_message.text.isNotEmpty) {
  //     Map<String, dynamic> chatData = {
  //       "sendBy": _auth.currentUser!.displayName,
  //       "message": _message.text,
  //       "type": "text",
  //       "time": FieldValue.serverTimestamp(),
  //       "messageId" :uuid.v1(),
  //
  //     };
  //
  //     _message.clear();
  //
  //     await _firestore
  //         .collection('groups')
  //         .doc(groupChatId)
  //         .collection('chats')
  //         .add(chatData);
  //   }
  // }



  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      String messageId = Uuid().v1();
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "messageId": messageId,
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .doc(messageId)
          .set(chatData);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          GroupInfo(
                            groupName: groupName,
                            groupId: groupChatId,
                          ),
                    ),
                  ),
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                        snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                        return messageTile(context,size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                       controller: _message,
                        decoration: InputDecoration(
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteMessage(messageId) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupChatId)
        .collection('chats')
        .doc(messageId)
        .delete();
    log("Message deleted!");
  }

  void onEditMessage(BuildContext context, String messageId, String currentMessage) async {
    TextEditingController editMessageController = TextEditingController(
      text: currentMessage,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Message"),
          content: TextField(
            controller: editMessageController,
            decoration: const InputDecoration(hintText: "Edit your message"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: ()  {
                String editedMessage = editMessageController.text;
                print("Edit message ${editedMessage}");
                print(" message ${messageId}");
                   _firestore
                      .collection('groups')
                      .doc(groupChatId)
                      .collection('chats')
                      .doc(messageId)
                      .update({
                    "message": editedMessage,
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();



              },
            ),
          ],
        );
      },
    );
  }
  void onEditMessageDialogue(BuildContext context, String messageId, String currentMessage, isCurrentUser) async {
    // Show a dialog or a bottom sheet for editing
    TextEditingController editMessageController = TextEditingController(
      text: currentMessage,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want to delete or edit a message"),
          actions: <Widget>[
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                deleteMessage(messageId);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if(isCurrentUser)
            TextButton(
              child: const Text("Edit"),
              onPressed: () {
                Navigator.of(context).pop();
                onEditMessage(context, messageId, currentMessage);
                // Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }


  Widget messageTile(BuildContext context,Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
bool isCurrent = chatMap['sendBy'] == _auth.currentUser!.displayName;
      if (chatMap['type'] == "text") {
        return Column(
          children: [
            GestureDetector(
              onLongPress: () {
                onEditMessageDialogue(context, chatMap['messageId'].toString(), chatMap['message'] , isCurrent);
              },
              child: Container(
                width: size.width,
                alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Text(
                        chatMap['sendBy'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: size.height / 200,
                      ),
                      Text(
                        chatMap['message'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Edit button for messages sent by the current user

          ],
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: size.height / 2,
            child: Image.network(
              chatMap['message'],
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
