//
// import 'package:chatapp/Screen/homescreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
//
// import 'HomeChat.dart';
//
// class ChatRoom extends StatelessWidget {
//   final Map<String, dynamic> userMap;
//   final String chatRoomId;
//
//   ChatRoom({required this.chatRoomId, required this.userMap});
//
//   final TextEditingController _message = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   File? imageFile;
//
//   Future getImage() async {
//     ImagePicker _picker = ImagePicker();
//
//     await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
//       if (xFile != null) {
//         imageFile = File(xFile.path);
//         uploadImage();
//       }
//     });
//   }
//
//   Future uploadImage() async {
//     String fileName = Uuid().v1();
//     int status = 1;
//
//     await _firestore
//         .collection('chatroom')
//         .doc(chatRoomId)
//         .collection('chats')
//         .doc(fileName)
//         .set({
//       "sendby": _auth.currentUser!.displayName,
//       "message": "",
//       "type": "img",
//       "time": FieldValue.serverTimestamp(),
//     });
//
//     /* `````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~`````````````~~~~~~~ */
//
//     var ref =
//     FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
//
//     var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .doc(fileName)
//           .delete();
//
//       status = 0;
//     });
//
//     if (status == 1) {
//       String imageUrl = await uploadTask.ref.getDownloadURL();
//
//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .doc(fileName)
//           .update({"message": imageUrl});
//
//       print(imageUrl);
//     }
//   }
//
//   void onSendMessage() async {
//     if (_message.text.isNotEmpty) {
//       Map<String, dynamic> messages = {
//         "sendby": _auth.currentUser!.displayName,
//         "message": _message.text,
//         "type": "text",
//         "time": FieldValue.serverTimestamp(),
//       };
//
//       _message.clear();
//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .add(messages);
//     } else {
//       print("Enter Some Text");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//
//         title: StreamBuilder<DocumentSnapshot>(
//           stream:
//           _firestore.collection("users").doc(userMap['uid']).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.data != null) {
//               return Container(
//                 child: Column(
//                   children: [
//                     Text(userMap['name']),
//                     Text(
//                       snapshot.data!['status'],
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Container();
//             }
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: size.height / 1.25,
//               width: size.width,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('chatroom')
//                     .doc(chatRoomId)
//                     .collection('chats')
//                     .orderBy("time", descending: false)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.data != null) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         Map<String, dynamic> map = snapshot.data!.docs[index]
//                             .data() as Map<String, dynamic>;
//                         return messages(size, map, context);
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//             Container(
//               height: size.height / 10,
//               width: size.width,
//               alignment: Alignment.center,
//               child: Container(
//                 height: size.height / 12,
//                 width: size.width / 1.1,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: size.height / 17,
//                       width: size.width / 1.3,
//                       child: TextField(
//                         controller: _message,
//                         decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                               onPressed: () => getImage(),
//                               icon: Icon(Icons.photo),
//                             ),
//                             hintText: "Send Message",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             )),
//                       ),
//                     ),
//                     IconButton(
//                         icon: Icon(Icons.send), onPressed: onSendMessage),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
//     return map['type'] == "text"
//         ? Container(
//       width: size.width,
//       alignment: map['sendby'] == _auth.currentUser!.displayName
//           ? Alignment.centerRight
//           : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.blue,
//         ),
//         child: Text(
//           map['message'],
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     )
//         : Container(
//       height: size.height / 2.5,
//       width: size.width,
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       alignment: map['sendby'] == _auth.currentUser!.displayName
//           ? Alignment.centerRight
//           : Alignment.centerLeft,
//       child: InkWell(
//         onTap: () => Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => ShowImage(
//               imageUrl: map['message'],
//             ),
//           ),
//         ),
//         child: Container(
//           height: size.height / 2.5,
//           width: size.width / 2,
//           decoration: BoxDecoration(border: Border.all()),
//           alignment: map['message'] != "" ? null : Alignment.center,
//           child: map['message'] != ""
//               ? Image.network(
//             map['message'],
//             fit: BoxFit.cover,
//           )
//               : CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }
//
// class ShowImage extends StatelessWidget {
//
//   final String imageUrl;
//
//   const ShowImage({required this.imageUrl, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Container(
//         height: size.height,
//         width: size.width,
//         color: Colors.black,
//         child: Image.network(imageUrl),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/ChatRoomModel.dart';
import '../Models/MessageModel.dart';
import '../Models/UserModel.dart';
import '../main.dart';

class ChatRoomPage extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  ChatRoomPage(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  TextEditingController messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(chatroom.chatroomid)
          .set(chatroom.toMap());

      log("Message Sent!");
    }
  }

  void deleteMessage(messageId) async {
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroom.chatroomid)
        .collection("messages")
        .doc(messageId)
        .delete();
    log("Message deleted!");
  }

  void editMessage(String messageId, String newText) async {
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroom.chatroomid)
        .collection("messages")
        .doc(messageId)
        .update({
      "text": newText,
      "edited": true,
      "editedOn": DateTime.now(),
    });

    log("Message edited!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection("users")
                  .doc(targetUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        // backgroundImage: NetworkImage(targetUser.profilpic.toString()),
                        backgroundImage:
                            NetworkImage(snapshot.data!['profilpic']),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!['name'],
                              style: const TextStyle(fontSize: 24)),
                          Text(
                            snapshot.data!['status'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatroom")
                        .doc(chatroom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                MessageModel currentMessage =
                                    MessageModel.fromMap(
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>);

                                bool isCurrentUserMessage =
                                    currentMessage.sender == userModel.uid;
                                return GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              children: [
                                                const Center(
                                                  child: Text('Delete or Edit',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                const Text(
                                                    'Are you want to Delete or Edit this Message'),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ElevatedButton(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteMessage(
                                                            currentMessage
                                                                .messageid);
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                    ElevatedButton(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('No'),
                                                    ),
                                                    if (isCurrentUserMessage)
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.blue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          // Show an edit message dialog or text field here
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              TextEditingController
                                                                  editController =
                                                                  TextEditingController(
                                                                      text: currentMessage
                                                                          .text);
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Edit Message'),
                                                                content:
                                                                    TextField(
                                                                  controller:
                                                                      editController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Enter edited message',
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      String
                                                                          editedText =
                                                                          editController
                                                                              .text
                                                                              .trim();
                                                                      if (editedText
                                                                          .isNotEmpty) {
                                                                        editMessage(
                                                                            currentMessage.messageid.toString(),
                                                                            editedText);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        'Save'),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancel'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text('Edit'),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                            (currentMessage.sender ==
                                                    userModel.uid)
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          if (currentMessage.sender ==
                                              targetUser.uid)
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  targetUser.profilpic
                                                      .toString()),
                                            ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: (currentMessage.sender ==
                                                        userModel.uid)
                                                    ? Colors.grey
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                currentMessage.text.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          if (currentMessage.sender ==
                                              userModel.uid)
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  userModel.profilpic.toString()),
                                            )
                                        ]),
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "An error occured! Please check your internet connection."),
                          );
                        } else {
                          return Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
