import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_app/pages/home_page.dart';

import '../models/UIHelper.dart';
import '../models/UserModel.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfilePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  TextEditingController fullNameController = TextEditingController();

  File? imageFile;

  void selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  Future<void> cropImage(file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 30,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),

        /// this settings is required for Web
        // WebUiSettings(
        //   context: context,
        //   presentStyle: CropperPresentStyle.dialog,
        //   boundary: const CroppieBoundary(
        //     width: 250,
        //     height: 250,
        //   ),
        //   viewPort:
        //       const CroppieViewPort(width: 220, height: 220, type: 'circle'),
        //   enableExif: true,
        //   enableZoom: true,
        //   showZoomer: true,
        // )
      ],
    );

    if (croppedImage != null) {
      File? croppedFile = File(croppedImage.path);
      setState(() {
        imageFile = croppedFile;
      });
    }
  }

  //Where to select image dialog
  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Select from gallery'),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Check values on of the fields
  void checkValues() {
    String fullName = fullNameController.text.trim();
    if (fullName.isEmpty) {
      UIHelper.showAlertDialog(
          context, 'Incomplete date!', "Please enter your full name");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, 'Uploading data...');
    String imageUrl;
    String fullUserName = fullNameController.text.trim();
    if (imageFile != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref('profilePictures')
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      imageUrl = await snapshot.ref.getDownloadURL();
    } else {
      imageUrl = '';
    }

    UserModel userModel = UserModel(
      email: widget.userModel.email,
      uid: widget.userModel.uid,
      fullName: fullUserName,
      profilePic: imageUrl,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .set(userModel.toJson())
        .then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
              userModel: userModel, firebaseUser: widget.firebaseUser),
        ),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                onPressed: () {
                  showPhotoOptions();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  checkValues();
                  debugPrint('uploading data');
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
