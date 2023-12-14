import 'package:chatapp/Auth/Login.dart';
import 'package:chatapp/Screen/account_screen.dart';
import 'package:chatapp/Screen/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Models/ChatRoomModel.dart';
import '../Models/FirebaseHelper.dart';
import '../Models/UserModel.dart';
import '../group_chats/group_chat_screen.dart';
import 'SearchPage.dart';

class HomeChat extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeChat(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomeChatState createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
      userMap = null;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("No Data Found"),
              content:
                  const Text("No user with the specified email was found."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void showLogoutDialogue() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Center(
                  child: Text('Logout',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Are you want to Logout'),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No')),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text('Yes')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteChatRoom(chatroomId) async {
    // Delete all messages in the chat room
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomId)
        .collection("messages")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Delete the chat room itself
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomId)
        .delete();

    print("Chat room deleted!");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Chat App"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatHomeScreen(),
                      ));
                },
                icon: Icon(Icons.group)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountScreen(userModel: widget.userModel),
                      ));
                },
                icon: Icon(Icons.account_circle_outlined)),
          ],
          leading: IconButton(
            onPressed: () async {
              showLogoutDialogue();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 500));
            setState(() {});
          },
          child: SafeArea(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatroom")
                    .where("participants.${widget.userModel.uid}",
                        isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          Map<String, dynamic> participants =
                              chatRoomModel.participants!;

                          List<String> participantKeys =
                              participants.keys.toList();
                          participantKeys.remove(widget.userModel.uid);

                          return FutureBuilder(
                            future: FirebaseHelper.getGroupUserModelById(
                                participantKeys[0]),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  UserModel targetUser =
                                      userData.data as UserModel;

                                  return ListTile(
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
                                                  Center(
                                                    child: Text('Delete',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text(
                                                      'Are you want to Delete this Message'),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Colors
                                                                          .blue)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('No')),
                                                      ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Colors
                                                                          .blue)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            deleteChatRoom(
                                                                chatRoomModel
                                                                    .chatroomid);
                                                          },
                                                          child: Text('Yes')),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      //
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return ChatRoomPage(
                                            chatroom: chatRoomModel,
                                            firebaseUser: widget.firebaseUser,
                                            userModel: widget.userModel,
                                            targetUser: targetUser,
                                          );
                                        }),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          // AssetImage('assets/images/person.png'),
                                          NetworkImage(
                                              targetUser.profilpic.toString()),
                                    ),
                                    trailing: Icon(Icons.message),
                                    title: Text(targetUser.fullname.toString()),
                                    subtitle:
                                        (chatRoomModel.lastMessage.toString() !=
                                                "")
                                            ? Text(chatRoomModel.lastMessage
                                                .toString())
                                            : Text(
                                                "Say hi to your new friend!",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: Text("No Chats"),
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchPage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
              // return SearchPage(GroupUserModel: widget.GroupUserModel, firebaseUser: widget.firebaseUser);
            }));
          },
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}
