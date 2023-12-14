
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   Map<String, dynamic>?   userMap;
//   bool isLoading = false;
//   final TextEditingController _search = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String chatRoomId(String user1, String user2) {
//     if (user1[0].toLowerCase().codeUnits[0] >
//         user2.toLowerCase().codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }
//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//     setState(() {
//       isLoading = true;
//       userMap = null; // Reset the userMap when a new search is initiated.
//     });
//
//     await _firestore
//         .collection('users')
//         .where("email", isEqualTo: _search.text)
//         .get()
//         .then((value) {
//       setState(() {
//         isLoading = false;
//       });
//
//       if (value.docs.isNotEmpty) {
//         // Search result found, update userMap.
//         setState(() {
//           userMap = value.docs[0].data();
//         });
//       } else {
//         // No data found, show an error message.
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text("No Data Found"),
//               content: Text("No user with the specified email was found."),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title:  Text('Search Page'),
//
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: size.height / 14,
//             width: size.width,
//             alignment: Alignment.center,
//             child: Container(
//               height: size.height / 14,
//               width: size.width / 1.15,
//               child: TextField(
//                 controller: _search,
//                 decoration: InputDecoration(
//                   hintText: "Search",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height / 50,
//           ),
//           ElevatedButton(
//             onPressed: onSearch,
//             child: Text("Search"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/ChatRoomModel.dart';
import '../Models/UserModel.dart';
import '../main.dart';
import 'chat_room.dart';


class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic>? userMap;

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatroom").where("participants.${widget.userModel.uid}", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();

    if(snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    }
    else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance.collection("chatroom").doc(newChatroom.chatroomid).set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Email Address"
                ),
              ),

              SizedBox(height: 20,),

              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text("Search"),
              ),

              SizedBox(height: 20,),

              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").where("email", isEqualTo: searchController.text).where("email", isNotEqualTo: widget.userModel.email).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active) {
                      if(snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                        if(dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);

                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);

                              if(chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoomPage(
                                        targetUser: searchedUser,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                        chatroom: chatroomModel,
                                      );
                                    }
                                ));
                              }
                            },
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(userMap.),
                            // ),
                            title: Text(searchedUser.fullname!),
                            subtitle: Text(searchedUser.email!),
                            trailing: Icon(Icons.message),
                          );
                        }
                        else {
                          return Text("No results found!");
                        }

                      }
                      else if(snapshot.hasError) {
                        return Text("An error occured!");
                      }
                      else {
                        return Text("No results found!");
                      }
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }
}