import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:flutter/material.dart';
class OrderProvider with ChangeNotifier{
  confirmedUserOrderReceived(BuildContext context,String productShortInfo )async{
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders).doc(productShortInfo).delete();
    notifyListeners();
      productShortInfo = '' ;
      Route route = MaterialPageRoute(builder: (c)=>StoreHome());
      Navigator.pushReplacement(context, route);

    notifyListeners();
  }
  deleteOrder(BuildContext context,String productShortInfo )async{
    EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders).doc(productShortInfo).delete();
    notifyListeners();
    productShortInfo = '' ;
    notifyListeners();
  }
}