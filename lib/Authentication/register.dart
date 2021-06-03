import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:commerce/DialogBox/loadingDialog.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:commerce/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";

  File _imageFile;

  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.blue[900],
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _nameController,
                    data: Icons.person,
                    hintText: 'name',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    data: Icons.email,
                    hintText: 'E-mail',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            WideButton(
              message: 'Sign Up',
              onPressed: () {
                uploadAndSaveImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    final pickedImageFile =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      setState(() {
        _imageFile = File(pickedImageFile.path);
      });
    }
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'please select an image.',
            );
          });
    } else {
      _passwordController.text == _confirmPasswordController.text
          ? _emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _confirmPasswordController.text.isNotEmpty &&
                  _nameController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog('please fill all the requirements')
          : displayDialog('Passwords does not match');
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  Future<void> uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registering, Please wait.....',
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((url) {
        setState(() {
          userImageUrl = url;
        });
      });
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameController.text.trim());
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
