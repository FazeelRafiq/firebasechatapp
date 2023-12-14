import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('UR; $downloadUrl');
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = "Some Error Occurred";
    try {
      String imageUrl = await uploadImageToStorage('profilePic', file);
      await firestore.collection('users').add({
        'profilePic': imageUrl,
      });
      resp = 'Success';
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
