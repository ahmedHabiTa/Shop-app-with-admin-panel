import 'package:commerce/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AdminProductDetailsProvider with ChangeNotifier{
  bool uploading = false ;
  updateProduct(int price, int oldPrice, int discount, String shortInfo, String title)async{
uploading = true ;
     await EcommerceApp.firestore.collection('items').doc(shortInfo).update({
      "price" : price,
      "old_price" : oldPrice,
      "discount" : discount,
      "shortInfo" : shortInfo,
      "title" : title,
    }).then((value) {
      Fluttertoast.showToast(msg: 'Updated');
        uploading = false ;
    });
    notifyListeners();
  }
}