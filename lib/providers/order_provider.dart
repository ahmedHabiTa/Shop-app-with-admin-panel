import 'package:commerce/Config/config.dart';
import 'package:commerce/Orders/myOrders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class OrderProvider with ChangeNotifier{
  confirmedUserOrderReceived(BuildContext context,String productShortInfo,String text )async{
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders).doc(productShortInfo).delete();
    notifyListeners();
      productShortInfo = '' ;
      Route route = MaterialPageRoute(builder: (c)=>MyOrders());
      Navigator.pushReplacement(context, route);

    notifyListeners();
  }

}