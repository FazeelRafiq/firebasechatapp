import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'Login.dart';

Future<User?> createAccount(String name, String email, String password,  imageFile) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  try {
    // Create user in Firebase Authentication
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Upload the image to Firebase Storage
    String imageFileName = 'user_profile_${userCredential.user!.uid}.jpg';
    UploadTask uploadTask = _storage.ref('profile_images/$imageFileName').putFile(imageFile);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => {});

    // Get the download URL of the uploaded image
    String imageUrl = await storageSnapshot.ref.getDownloadURL();

    // Update user's display name and store user data in Firestore
    await userCredential.user!.updateDisplayName(name);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      "name": name,
      "email": email,
      "status": "Unavailable",
      "uid": userCredential.user!.uid,
      "profilpic": imageUrl, // Store the image URL in Firestore
    });

    print("Account created successfully");
    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfully");
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    return userCredential.user;
  } catch (e) {
    print('Errorss $e');
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print("error");
  }
}
