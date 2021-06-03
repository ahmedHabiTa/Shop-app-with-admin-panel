import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Orders/orders_screen.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/order_provider.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID});

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
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
                          SizedBox(
                            height: 20,
                          ),
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
                                'Total price : EGP ' +
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
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                  fontSize: 16),
                            ),
                          ),
                          Divider(
                            height: 4,
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
        floatingActionButton: WideButton(
          message: 'Back',
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
    status ? msg = "Successfully" : msg = "UnSuccessfully";
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      margin: EdgeInsets.only(right: 10, left: 10),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(1),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: themeMode == ThemeMode.dark
              ? Theme.of(context).canvasColor
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Text(
              "Order Placed " + msg,
              style: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 20),
            ),
            SizedBox(
              width: 5,
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor:
                  themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
              child: Center(
                child: Icon(
                  iconData,
                  color: themeMode == ThemeMode.dark
                      ? Colors.black87
                      : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model});

  @override
  Widget build(BuildContext context) {

    var themeMode = Provider.of<ThemeProvider>(context).tm;
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
        Card(
          semanticContainer: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
          child: Padding(
            padding: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark
                    ? Theme.of(context).canvasColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
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
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: WideButton(
              message: 'Confirmed,Order Received',
              onPressed:() {
                Provider.of<OrderProvider>(context, listen: false)
                    .confirmedUserOrderReceived(context, getOrderId);
                Fluttertoast.showToast(msg: 'Order Received confirmed');
              } ,
            ),
          ),
        ),
      ],
    );
  }
}
