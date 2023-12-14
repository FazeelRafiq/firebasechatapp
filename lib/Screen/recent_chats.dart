// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'chat_room.dart';
// import 'homescreen.dart';
//
// class RecentChats extends StatefulWidget {
//   const RecentChats({super.key});
//
//   @override
//   State<RecentChats> createState() => _RecentChatsState();
// }
//
// class _RecentChatsState extends State<RecentChats> {
//
//   Map<String, dynamic>? userMap;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool isLoading = false;
//
//
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
//
//
//   String chatRoomId(String user1, String user2) {
//     if (user1[0].toLowerCase().codeUnits[0] >
//         user2.toLowerCase().codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return  Scaffold(
//       body: isLoading
//           ? Center(
//         child: Container(
//           height: size.height / 20,
//           width: size.height / 20,
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : Column(
//         children: [
//           SizedBox(
//             height: size.height / 20,
//           ),
//           // Container(
//           //   height: size.height / 14,
//           //   width: size.width,
//           //   alignment: Alignment.center,
//           //   child: Container(
//           //     height: size.height / 14,
//           //     width: size.width / 1.15,
//           //     child: TextField(
//           //       controller: _search,
//           //       decoration: InputDecoration(
//           //         hintText: "Search",
//           //         border: OutlineInputBorder(
//           //           borderRadius: BorderRadius.circular(10),
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           SizedBox(
//             height: size.height / 50,
//           ),
//           ElevatedButton(
//             onPressed: onSearch,
//             child: Text("Load Chats"),
//           ),
//           SizedBox(
//             height: size.height / 30,
//           ),
//           userMap != null
//               ? ListTile(
//             onTap: () {
//               String roomId = chatRoomId(
//                   _auth.currentUser!.displayName!,
//                   userMap!['name']);
//
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => ChatRoom(
//                     chatRoomId: roomId,
//                     userMap: userMap!,
//                   ),
//                 ),
//               );
//             },
//             leading: Icon(Icons.account_box, color: Colors.black),
//             title: Text(
//               userMap!['name'],
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 17,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             subtitle: Text(userMap!['email']),
//             trailing: Icon(Icons.chat, color: Colors.black),
//           )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
