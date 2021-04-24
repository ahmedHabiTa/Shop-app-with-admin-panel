import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Address/check_out_address.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Orders/myOrders.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/orderCard.dart';
import 'package:commerce/providers/order_provider.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .doc(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Center(
                                  child: Text(
                                'Total price : \$ ' +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('Order ID : ' + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              'Ordered at :' +
                                  DateFormat("dd MMMM,yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap['orderTime']))),
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 16),
                            ),
                          ),
                          Divider(
                            height: 2,
                          ),
                          // FutureBuilder<QuerySnapshot>(
                          //   future: EcommerceApp.firestore.collection('items')
                          //       .where('shortInfo',whereIn: dataMap[EcommerceApp.productID]).get(),
                          //   builder: (c,dataSnapshot){
                          //     return dataSnapshot.hasData
                          //         ? OrderCard(
                          //       itemCount: dataSnapshot.data.docs.length,
                          //       data:  dataSnapshot.data.docs,
                          //     )
                          //         : Center(child: circularProgress(),);
                          //   },
                          // ),
                          Divider(
                            height: 2,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model: AddressModel.fromJson(
                                          snap.data.data()),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          child: Text('Back'),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => MyOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.pink, Colors.lightGreenAccent],
        begin: const FractionalOffset(0, 0),
        end: FractionalOffset(1, 0),
        stops: [0, 1],
        tileMode: TileMode.clamp,
      )),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // GestureDetector(
          //   onTap: (){
          //     Route route = MaterialPageRoute(builder: (c)=>StoreHome());
          //     Navigator.pushReplacement(context, route);
          //   },
          //   child: Container(
          //     child: Icon(Icons.arrow_back,color: Colors.white,),
          //   ),
          // ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Shipment Details : ',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  "Name : ",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  model.name,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ]),
              TableRow(children: [
                Text("Phone : ", style: Theme.of(context).textTheme.headline3),
                Text(model.phoneNumber,
                    style: Theme.of(context).textTheme.headline3),
              ]),
              TableRow(children: [
                Text("Flat : ", style: Theme.of(context).textTheme.headline3),
                Text(model.flatNumber,
                    style: Theme.of(context).textTheme.headline3),
              ]),
              TableRow(children: [
                Text("City : ", style: Theme.of(context).textTheme.headline3),
                Text(model.city, style: Theme.of(context).textTheme.headline3),
              ]),
              TableRow(children: [
                Text("Country : ",
                    style: Theme.of(context).textTheme.headline3),
                Text(model.state, style: Theme.of(context).textTheme.headline3),
              ]),
              TableRow(children: [
                Text("Pin Code : ",
                    style: Theme.of(context).textTheme.headline3),
                Text(model.pincode,
                    style: Theme.of(context).textTheme.headline3),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .confirmedUserOrderReceived(
                        context, getOrderId, 'Confirmed,Order Received');
              },
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0, 0),
                  end: FractionalOffset(1, 0),
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                )),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: Center(
                  child: Text(
                    'Confirmed,Order Received',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
