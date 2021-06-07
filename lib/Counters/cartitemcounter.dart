
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/item.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CartItemCounter with ChangeNotifier {
  int _counter ;

  int get count => _counter;

  Future<void> displayResult() async {
     _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length-1 ;
    notifyListeners();
  }

  Future<void> removeItemFromCart(String productShortInfo) async {
    final existingShotInfo = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartList)
        .indexWhere((shortInf) => shortInf == productShortInfo);
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.removeAt(existingShotInfo);
    notifyListeners();
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({EcommerceApp.userCartList: tempCartList}).then((v) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);

    });
    notifyListeners();
  }

  Future<void> addItemToCart(String productID, BuildContext context) async{
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.add(productID);
    notifyListeners();
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({EcommerceApp.userCartList: tempCartList}).then((v) {
      Fluttertoast.showToast(msg: "Item Added To Cart");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
    });

    notifyListeners();
  }
}
