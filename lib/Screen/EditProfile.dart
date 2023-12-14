import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../Models/UserModel.dart';
import '../Models/user_image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const EditProfileScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.userModel.fullname.toString();
    _emailController.text = widget.userModel.email.toString();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // void _updateProfile() async {
  //   // Get the current user's UID.
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   // Generate a unique filename for the profile picture.
  //   String fileName = Uuid().v4(); // You can use any method to generate a unique name.
  //
  //   // Create a reference to the Firebase Storage location where you want to store the image.
  //   Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');
  //
  //   // Upload the image file to Firebase Storage.
  //   try {
  //     File imageFile = File('user_profile_${uid}.jpg'); // Replace with your image file path.
  //     await storageReference.putFile(imageFile);
  //
  //     // Get the download URL of the uploaded image.
  //     String downloadURL = await storageReference.getDownloadURL();
  //
  //     // Update the user's information in Firestore, including the profile picture URL.
  //     await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //       'name': _fullNameController.text,
  //       'email': _emailController.text,
  //       'profilePicture': downloadURL, // Add the profile picture URL to Firestore.
  //     });
  //
  //     Navigator.pop(context);
  //   } catch (error) {
  //     // Handle any errors that occur during the upload.
  //     print('Error uploading profile picture: $error');
  //   }
  // }

  void _updateProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (_selectedImage != null) {
        String fileName = Uuid().v4();

        Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName.jpg');
        await storageReference.putFile(_selectedImage!);
        String downloadURL = await storageReference.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': _fullNameController.text,
          'email': _emailController.text,
          'profilpic': downloadURL,
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': _fullNameController.text,
          'email': _emailController.text,
        });
      }

      Navigator.pop(context);
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Add form fields for editing.
            child: Column(
              children: [
                UserImagePickerEdit(onPickImage: (pickedImage) {
                  _selectedImage = pickedImage;
                }, userModel: widget.userModel,),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _updateProfile();
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          )

      ),
    );
  }
}