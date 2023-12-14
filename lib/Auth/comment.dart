// import 'package:chatapp/Auth/Login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import '../Models/UIHelper.dart';
// import '../Models/GroupUserModel.dart';
// import '../Screen/HomeChat.dart';
// import 'dart:developer';
// import 'dart:io';
// import 'Methods.dart';
//
//
// class CreateAccount extends StatefulWidget {
//   final GroupUserModel? GroupUserModel;
//   final User? firebaseUser;
//   const CreateAccount({Key? key,  this.GroupUserModel,  this.firebaseUser}) : super(key: key);
//   @override
//   _CreateAccountState createState() => _CreateAccountState();
// }
//
// class _CreateAccountState extends State<CreateAccount> {
//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isLoading = false;
//   File? imageFile;
//   TextEditingController fullNameController = TextEditingController();
//   void selectImage(ImageSource source) async {
//     XFile? pickedFile = await ImagePicker().pickImage(source: source);
//
//     if(pickedFile != null) {
//       cropImage(pickedFile);
//     }
//   }
//   void cropImage(XFile file) async {
//     File? croppedImage = await ImageCropper().cropImage(
//         sourcePath: file.path,
//         aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//         compressQuality: 20
//     );
//
//     if(croppedImage != null) {
//       setState(() {
//         imageFile = croppedImage;
//       });
//     }
//   }
//
//   void showPhotoOptions() {
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text("Upload Profile Picture"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//
//             ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 selectImage(ImageSource.gallery);
//               },
//               leading: Icon(Icons.photo_album),
//               title: Text("Select from Gallery"),
//             ),
//
//             ListTile(
//               onTap: () {
//                 Navigator.pop(context);
//                 selectImage(ImageSource.camera);
//               },
//               leading: Icon(Icons.camera_alt),
//               title: Text("Take a photo"),
//             ),
//
//           ],
//         ),
//       );
//     });
//   }
//
//   void uploadData() async {
//
//     UIHelper.showLoadingDialog(context, "Uploading image..");
//
//     UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures").child(widget.GroupUserModel!.uid.toString()).putFile(imageFile!);
//
//     TaskSnapshot snapshot = await uploadTask;
//
//     String? imageUrl = await snapshot.ref.getDownloadURL();
//     String? fullname = fullNameController.text.trim();
//
//     widget.GroupUserModel?.fullname = fullname;
//     widget.GroupUserModel?.profilpic = imageUrl;
//
//     await FirebaseFirestore.instance.collection("users").doc(widget.GroupUserModel?.uid).set(widget.GroupUserModel!.toMap()).then((value) {
//       log("Data uploaded!");
//       Navigator.popUntil(context, (route) => route.isFirst);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) {
//           return HomeChat(GroupUserModel: widget.GroupUserModel!, firebaseUser: widget.firebaseUser!);
//         }),
//       );
//     });
//   }
//
//   final RegExp _emailRegExp = RegExp(
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
//   );
//   final RegExp passRegExp = RegExp(
//       r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');
//
//   final maskFormatter = new MaskTextInputFormatter(
//       filter: { "#": RegExp(r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$') },
//       type: MaskAutoCompletionType.lazy
//   );
//
//
//
//
//
//   bool _isEmailValid = false;
//   bool _isPassValid = false;
//   void _validateEmail(String email) {
//     setState(() {
//       _isEmailValid = _emailRegExp.hasMatch(email);
//     });
//   }
//   void _validPass(String pass) {
//     setState(() {
//       _isPassValid = passRegExp.hasMatch(pass);
//     });
//   }
//
//   bool _passwordVisible = true;
//
//   void initState(){
//     _passwordVisible = true;
//   }
//   final _key = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return WillPopScope(
//       onWillPop: () async{
//         return false;
//       },
//       child: Scaffold(
//         body: isLoading
//             ? Center(
//           child: Container(
//             height: size.height / 20,
//             width: size.height / 20,
//             child: CircularProgressIndicator(),
//           ),
//         )
//             : Form(
//           key: _key,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//
//                 SizedBox(
//                   height: size.height / 50,
//                 ),
//                 Center(
//                   child: Container(
//                     width: size.width / 1.1,
//                     child: Text(
//                       "Welcome",
//                       style: TextStyle(
//                         fontSize: 34,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Container(
//                     width: size.width / 1.1,
//                     child: Text(
//                       "Create Account to Contiue!",
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//
//                 CupertinoButton(
//                   onPressed: () {
//                     showPhotoOptions();
//                   },
//                   padding: EdgeInsets.all(0),
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundImage: (imageFile != null) ? FileImage(imageFile!) : null,
//                     child: (imageFile == null) ? Icon(Icons.person, size: 60,) : null,
//                   ),
//                 ),
//
//                 SizedBox(height: 20,),
//                 Padding(
//                   padding: EdgeInsets.all(15),
//                   child: TextFormField(
//                     controller: _name,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefix: Icon(Icons.person),
//                         label: Text('Name')
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter name';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: TextFormField(
//                     controller: _email,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         prefix: Icon(Icons.email_outlined),
//                         label: Text('Email')),
//                     onChanged: (value) {
//                       _validateEmail(value);
//                     },
//                     // validator: (value) {
//                     //   if (value == null || value.isEmpty) {
//                     //     return 'Please enter email';
//                     //   }
//                     //   return null;
//                     // },
//                     validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains('.')
//                         ? "enter a valid eamil"
//                         : null,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: TextFormField(
//
//                     controller: _password,
//                     inputFormatters: [maskFormatter],
//                     obscureText: _passwordVisible,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)
//                       ),
//                       prefix: SizedBox(
//                           width: 50,
//                           child: Icon(Icons.password)),
//                       label: Text('Password'),
//                       hintText: "Password",
//                       // errorText: _isPassValid ? null : 'Invalid password format',
//
//                       // errorText: _isPassValid ? null : 'Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 special character, 1 number, and be between 8 and 30 characters long.',
//                       suffixIcon: IconButton(
//                         icon: Icon(
//
//                           _passwordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _passwordVisible = !_passwordVisible;
//                           });
//                         },
//                       ),
//                     ),
//                     onChanged: (password) => onPasswordChanged(password),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter password';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 30,),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                             color: _isPasswordEightCharacters ?  Colors.green : Colors.red,
//                             border: _isPasswordEightCharacters ? Border.all(color: Colors.transparent) :
//                             Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(50)
//                         ),
//                         child: Center(child: Icon( _isPasswordEightCharacters ? Icons.check : Icons.clear, color: Colors.white, size: 15,),),
//                       ),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("Contains at least 8 characters")
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                             color: _hasPasswordOneNumber ?  Colors.green : Colors.red,
//                             border: _hasPasswordOneNumber ? Border.all(color: Colors.transparent) :
//                             Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(50)
//                         ),
//                         child: Center(child: Icon( _hasPasswordOneNumber ? Icons.check : Icons.clear, color: Colors.white, size: 15,),),
//                       ),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("Contains at least 1 number")
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                             color: _hasPasswordSpecialChar ?  Colors.green : Colors.red,
//                             border: _hasPasswordSpecialChar ? Border.all(color: Colors.transparent) :
//                             Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(50)
//                         ),
//                         child: Center(child: Icon( _hasPasswordSpecialChar ? Icons.check : Icons.clear, color: Colors.white, size: 15,),),
//                       ),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("Contains at least Special Chracter")
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 500),
//                         width: 20,
//                         height: 20,
//                         decoration: BoxDecoration(
//                             color: _hasPasswordCapLet ?  Colors.green : Colors.red,
//                             border: _hasPasswordCapLet ? Border.all(color: Colors.transparent) :
//                             Border.all(color: Colors.grey.shade400),
//                             borderRadius: BorderRadius.circular(50)
//                         ),
//                         child: Center(child: Icon( _hasPasswordCapLet ? Icons.check : Icons.clear, color: Colors.white, size: 15,),),
//                       ),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("Contains at least Capital Letter")
//                   ],
//                 ),
//                 SizedBox(height: 50,),
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//                 customButton(size),
//                 // ElevatedButton(onPressed: () {
//                 //     if (_key.currentState!.validate()) {
//                 //     if (_name.text.isNotEmpty &&
//                 //         _email.text.isNotEmpty &&
//                 //         _password.text.isNotEmpty) {
//                 //       setState(() {
//                 //         isLoading = true;
//                 //       });
//                 //
//                 //       createAccount(_name.text, _email.text, _password.text).then((user) {
//                 //         if (user != null) {
//                 //           setState(() {
//                 //             isLoading = false;
//                 //           });
//                 //           Navigator.push(
//                 //               context, MaterialPageRoute(builder: (_) => LoginScreen()));
//                 //           print("Account Created Sucessfull");
//                 //         } else {
//                 //           print("Login Failed");
//                 //           setState(() {
//                 //             isLoading = false;
//                 //           });
//                 //         }
//                 //       });
//                 //     } else {
//                 //       print("Please enter Fields");
//                 //     }
//                 //   }
//                 // }, child: Text('Create Account')),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Text(
//                       "Login",
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   bool _isVisible = false;
//   bool _isPasswordEightCharacters = false;
//   bool _hasPasswordOneNumber = false;
//   bool _hasPasswordSpecialChar = false;
//   bool _hasPasswordCapLet = false;
//
//   onPasswordChanged(String password) {
//     final numericRegex = RegExp(r'[0-9]');
//     final capLetRegex = RegExp(r'[A-Z]');
//     final specialCharRegex = RegExp(r'[|!#$%&()*+,-./:;<=>?@[\]^_{|}~]',);
//
//     setState(() {
//       _isPasswordEightCharacters = false;
//       if(password.length >= 8)
//         _isPasswordEightCharacters = true;
//
//       _hasPasswordOneNumber = false;
//       if(numericRegex.hasMatch(password))
//         _hasPasswordOneNumber = true;
//
//       _hasPasswordSpecialChar = false;
//       if(specialCharRegex.hasMatch(password))
//         _hasPasswordSpecialChar = true;
//
//       _hasPasswordCapLet = false;
//       if(capLetRegex.hasMatch(password))
//         _hasPasswordCapLet = true;
//     });
//   }
//
//
//   Widget customButton(Size size) {
//     return GestureDetector(
//       onTap: () {
//         if (_key.currentState!.validate()) {
//           if (_name.text.isNotEmpty &&
//               _email.text.isNotEmpty &&
//               _password.text.isNotEmpty) {
//             uploadData();
//             setState(() {
//               isLoading = true;
//             });
//
//             createAccount(_name.text, _email.text, _password.text).then((user) {
//               if (user != null) {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => LoginScreen()));
//                 print("Account Created Sucessfull");
//               } else {
//                 print("Login Failed");
//                 setState(() {
//                   isLoading = false;
//                 });
//               }
//             });
//           } else {
//             print("Please enter Fields");
//           }
//         }
//       },
//       child: Container(
//           height: size.height / 14,
//           width: size.width / 1.2,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.blue,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             "Create Account",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           )),
//     );
//   }
//
//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 14,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }




//update profile
// Future<void> _updateProfilePicture(String imageUrl) async {
//   // Get the current user's UID.
//   String uid = FirebaseAuth.instance.currentUser!.uid;
//
//   try {
//     // Create a reference to the Firebase Storage location where you want to store the profile picture.
//     final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
//
//     // Upload the image to Firebase Storage.
//     await storageRef.putFile(File(imageUrl));
//
//     // Get the download URL for the uploaded image.
//     final String downloadURL = await storageRef.getDownloadURL();
//
//     // Update the user's profile picture URL in Firestore.
//     await FirebaseFirestore.instance.collection('users').doc(uid).update({
//       'profilpic': downloadURL,
//     });
//
//     // Optionally, update the GroupUserModel locally if needed.
//     // GroupUserModel.profilePicture = downloadURL;
//
//     // Close the edit profile screen and navigate back to AccountScreen.
//     Navigator.pop(context);
//   } catch (error) {
//     // Handle any errors that occur during the upload process.
//     print('Error updating profile picture: $error');
//     // You can show an error message to the user if needed.
//   }
// }



// ElevatedButton(
// onPressed: () async {
// // Open a file picker to select a new profile picture from the device.
// final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
// if (pickedFile != null) {
// _updateProfilePicture(pickedFile.path);
// }
// },
// child: Text('Change Profile Picture'),
// ),