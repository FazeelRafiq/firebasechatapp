import 'dart:math';

import 'package:chatapp/Auth/auth_services.dart';
import 'package:chatapp/Screen/HomeChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../Models/UserModel.dart';
import '../Screen/homescreen.dart';
import 'CreateAccount.dart';
import 'Methods.dart';
import '../main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key,}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  UserModel? userModel;
  UserCredential? firebaseUser;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  final RegExp passRegExp = RegExp(
      r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$');

  final maskFormatter = new MaskTextInputFormatter(filter: {
    "#": RegExp(
        r'(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$')
  }, type: MaskAutoCompletionType.lazy);

  bool _isEmailValid = false;
  bool _isPassValid = false;

  GoogleSignInAccount? currentuser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly'
      ]
  );

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid = _emailRegExp.hasMatch(email);
    });
  }

  void _validPass(String pass) {
    setState(() {
      _isPassValid = passRegExp.hasMatch(pass);
    });
  }

  bool _passwordVisible = true;


  void initState() {
    super.initState();
    _passwordVisible = true;
    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //   setState(() {
    //     currentuser = account;
    //   });
    //   if(currentuser!=null){
    //     print('User is Already Authenticated');
    //   }
    // });
    // _googleSignIn.signInSilently();

  }


  bool isLoading = false;
  final _key = GlobalKey<FormState>();
  late UserModel users;




  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
      final User? user = authResult.user;

      return await storeUserInfoInFirestore(user);
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<UserModel> storeUserInfoInFirestore(User? user) async {
    if (user == null) {
      throw Exception("User is null");
    }

    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot userDoc = await usersCollection.doc(user.uid).get();

    if (!userDoc.exists) {
      final UserModel userModel = UserModel(
        uid: user.uid,
        fullname: user.displayName ?? '',
        email: user.email ?? '',
        profilpic: user.photoURL ?? '',
      );

      await usersCollection.doc(user.uid).set({
        'name': userModel.fullname,
        'email': userModel.email,
        'profilpic': userModel.profilpic,
        'uid' : userModel.uid,
      });

      return userModel;
    } else {
      return UserModel(
        uid: user.uid,
        fullname: userDoc['name'],
        email: userDoc['email'],
        profilpic: userDoc['profilpic'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: isLoading
            ? Center(
          child: Container(
            height: size.height / 20,
            width: size.height / 20,
            child: CircularProgressIndicator(),
          ),
        )
            : Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                Container(
                  width: size.width / 1.1,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: size.width / 1.1,
                  child: Text(
                    "Sign In to Contiue!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    // inputFormatters: [maskFormatter],
                    controller: _email,
                    decoration: InputDecoration(
                        hintText: "abc@gmail.com",
                        // errorText: _isEmailValid ? null : 'Invalid email format',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefix: SizedBox(
                            width: 50, child: Icon(Icons.email_outlined)),
                        label: Text('Email')),
                    onChanged: (value) {
                      _validateEmail(value);
                    },
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter email';
                    //   }
                    //   return null;
                    // },
                    validator: (val) => val!.isEmpty ||
                        !val.contains("@") ||
                        !val.contains('.')
                        ? "enter a valid eamil"
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _password,
                    inputFormatters: [maskFormatter],
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefix: SizedBox(
                          width: 50, child: Icon(Icons.password)),
                      label: Text('Password'),
                      hintText: "Password",
                      // errorText: _isPassValid ? null : 'Invalid password format',

                      // errorText: _isPassValid ? null : 'Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 special character, 1 number, and be between 8 and 30 characters long.',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (password) => onPasswordChanged(password),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters
                                ? Colors.green
                                : Colors.red,
                            border: _isPasswordEightCharacters
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _isPasswordEightCharacters
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Contains at least 8 characters")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordOneNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordOneNumber
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Contains at least 1 number")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordSpecialChar
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordSpecialChar
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordSpecialChar
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Contains at least Special Chracter")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _hasPasswordCapLet
                                ? Colors.green
                                : Colors.red,
                            border: _hasPasswordCapLet
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            _hasPasswordCapLet
                                ? Icons.check
                                : Icons.clear,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Contains at least Capital Letter")
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                customButton(size),
                SizedBox(
                  height: size.height / 40,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () async {
                          UserModel? userModel = await signInWithGoogle();
                          UserCredential credential;
                          FirebaseAuth credentials = await FirebaseAuth.instance;
                          // credential = await FirebaseAuth.instance;
                          String uid = credentials.currentUser!.uid;

                          DocumentSnapshot userData = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get();
                          // UserModel userModel =
                          // UserModel.fromMap(userData.data() as Map<String, dynamic>);
                          if (userModel != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeChat(userModel: userModel, firebaseUser: credentials.currentUser!),
                              ),
                            );
                          }
                        },
                        child: Image.asset('assets/images/google0.png')),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () async {
                          UserModel? userModel = await signInWithGoogle();
                          UserCredential credential;
                          FirebaseAuth credentials = await FirebaseAuth.instance;
                          // credential = await FirebaseAuth.instance;
                          String uid = credentials.currentUser!.uid;

                          DocumentSnapshot userData = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .get();
                          // UserModel userModel =
                          // UserModel.fromMap(userData.data() as Map<String, dynamic>);
                          if (userModel != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeChat(userModel: userModel, firebaseUser: credentials.currentUser!),
                              ),
                            );
                          }
                        },
                        child: Image.asset('assets/images/facebook.png'))
                  ],
                ),
                // ElevatedButton(onPressed: () async {
                //   UserModel? userModel = await signInWithGoogle();
                //   UserCredential credential;
                //   FirebaseAuth credentials = await FirebaseAuth.instance;
                //   // credential = await FirebaseAuth.instance;
                //   String uid = credentials.currentUser!.uid;
                //
                //   DocumentSnapshot userData = await FirebaseFirestore.instance
                //       .collection('users')
                //       .doc(uid)
                //       .get();
                //   // UserModel userModel =
                //   // UserModel.fromMap(userData.data() as Map<String, dynamic>);
                //   if (userModel != null) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => HomeChat(userModel: userModel, firebaseUser: credentials.currentUser!),
                //       ),
                //     );
                //   }
                // }, child: Text('Google Sign In')),
                SizedBox(
                  height: size.height / 40,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CreateAccount())),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isVisible = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordSpecialChar = false;
  bool _hasPasswordCapLet = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final capLetRegex = RegExp(r'[A-Z]');
    final specialCharRegex = RegExp(
      r'[|!#$%&()*+,-./:;<=>?@[\]^_{|}~]',
    );

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;

      _hasPasswordSpecialChar = false;
      if (specialCharRegex.hasMatch(password)) _hasPasswordSpecialChar = true;

      _hasPasswordCapLet = false;
      if (capLetRegex.hasMatch(password)) _hasPasswordCapLet = true;
    });
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_key.currentState!.validate() || _isEmailValid || _isPassValid) {
          if (_email.text.isNotEmpty ||
              _password.text.isNotEmpty ||
              _isEmailValid ||
              _isPassValid) {
            setState(() {
              isLoading = true;
            });

            logIn(_email.text, _password.text).then((user) async {
              UserCredential? credential;
              credential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: _email.text, password: _password.text);
              String uid = credential.user!.uid;

              DocumentSnapshot userData = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();
              UserModel userModel =
              UserModel.fromMap(userData.data() as Map<String, dynamic>);

              // validatePassword();
              if (user != null) {
                print("Login Sucessfull");
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomeChat(
                            userModel: userModel,
                            firebaseUser: credential!.user!)));
              } else {
                // print("Login Failed");
                setState(() {
                  isLoading = false;
                });
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // title: Text("No Data Found"),
                      content: Text("Incorrect email and password , Try Again"),
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
          } else {
            print("Please fill form correctly");
          }
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );

  }
}

// in this code , add a function which check email or password is correct or incorrect . if email and password is incorrect show a promt incorrect email or password