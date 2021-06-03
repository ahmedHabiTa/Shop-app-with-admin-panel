import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final String addressID;
  final double totalAmount;

  PaymentPage({this.addressID, this.totalAmount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset("assets/images/cash.png"),
              ),
              SizedBox(
                height: 10,
              ),
              // ignore: deprecated_member_use
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(20)
                ),
                child: FlatButton(
                  padding: EdgeInsets.all(8),
                  splashColor: Colors.deepOrange,
                  onPressed: () => addOrderDetails(),
                  child: Text(
                    'Place Order',
                    style: TextStyle(fontSize: 30,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    });
    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressID,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "Cash on Delivery",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() {
      emptyCartNow();
    });
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
      Fluttertoast.showToast(msg: 'your Order has been Placed, successfully');
      Route route = MaterialPageRoute(builder: (c) => StoreHome());
      Navigator.push(context, route);
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }
}
