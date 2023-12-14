import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'create_group/add_members.dart';
import 'group_chat_room.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void deleteGroup(String groupId) async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .doc(groupId)
        .delete();

  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body:RefreshIndicator(
        onRefresh: () async{
          await Future.delayed(Duration(milliseconds: 500));
          setState(() {
            getAvailableGroups();
          });

        },
        child: ListView.builder(
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupChatRoom(
                    groupName: groupList[index]['name'],
                    groupChatId: groupList[index]['id'],
                  ),
                ),
              ),
              onLongPress: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Text('Delete',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text('Are you want to Delete this Message'),
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
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    deleteGroup(groupList[index]['id']);
                                    getAvailableGroups();

                                  },
                                  child: Text('Yes')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },);

              },
              leading: Icon(Icons.group),
              title: Text(groupList[index]['name']),

            );
          },
        ),
      ),

        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddMembersInGroup(),
          ),
        ),
        tooltip: "Create Group",
      ),
    );
  }
}
