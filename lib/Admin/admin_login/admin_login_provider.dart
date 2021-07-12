import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/admin_home_page/admin_home_screen.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLoginProvider with ChangeNotifier{

  loginAdmin(String id,String password,context) {
    FirebaseFirestore.instance.collection('admins').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result['id'] != id) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Invalid ID',),
          ));
        } else if (result['password'] != password) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Invalid Password'),
          ));
        } else {
          Fluttertoast.showToast(msg: 'Welcome dear Admin,${result['name']}');
          id = '';
          password = '';
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
    adminToken = true ;
    EcommerceApp.sharedPreferences.setBool('adminToken', adminToken);
    notifyListeners();
  }
}