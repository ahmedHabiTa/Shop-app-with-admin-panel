import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:commerce/DialogBox/loadingDialog.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AuthenticationProvider with ChangeNotifier{
  FirebaseAuth _auth = FirebaseAuth.instance;
  String userImageUrl = "";
  File imageFile;
  ImagePicker imagePicker = ImagePicker();
   loginUser(context,String email,String password) async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Logging, Please wait.....',
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
    notifyListeners();
  }
  Future readData(User fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userAvatarUrl, dataSnapshot[EcommerceApp.userAvatarUrl]);
      List<String> cartList =
      dataSnapshot[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
    notifyListeners();
  }
  Future<void> selectAndPickImage() async {
    final pickedImageFile =
    await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      imageFile = File(pickedImageFile.path);
    }
    notifyListeners() ;
  }
  Future<void> uploadAndSaveImage(context,String password,String confirmPassword,String email,String name,) async {
    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'please select an image.',
            );
          });
    } else {
      password == confirmPassword
          ? email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          name.isNotEmpty
          ? uploadToStorage(context,email,password,name)
          : displayDialog('please fill all the requirements',context)
          : displayDialog('Passwords does not match',context);
    }
    notifyListeners();
  }
  displayDialog(String msg,context) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }
  Future<void> uploadToStorage(context,String email,String password,String name) async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Registering, Please wait.....',
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((url) {
        userImageUrl = url;
      });
      _registerUser(context,email,password,name);
    });
    notifyListeners();
  }
  void _registerUser(context,String email,String password,String name) async {
    User firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim())
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
      saveUserInfoToFireStore(firebaseUser,name).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
    notifyListeners();
  }
  Future saveUserInfoToFireStore(User fUser,String name,) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": name.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    }).then((value) async{
      await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
      await EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userEmail, fUser.email);
      await EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userName, name.trim());
      await EcommerceApp.sharedPreferences
          .setString(EcommerceApp.userAvatarUrl, userImageUrl);
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    });
    notifyListeners();
  }
}