import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/admin_drawer.dart';
import 'package:commerce/Admin/admin_orders_screen.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'admin_home_page/admin_home_screen.dart';
String getOrderId = "";
class AdminOrderDetails extends StatelessWidget {
  final String orderID ;
  final String orderBy ;
  final String addressID ;
  AdminOrderDetails({this.orderID, this.orderBy, this.addressID});
  @override
  Widget build(BuildContext context) {
    getOrderId =orderID ;
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: WideButton(
        message: 'Back',
        onPressed: () {
          Route route = MaterialPageRoute(builder: (c) => AdminOrdersScreen());
          Navigator.pushReplacement(context, route);
        },
      ),
        drawer: AdminDrawer(),
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore.collection(EcommerceApp.collectionOrders)
                .doc(getOrderId).get(),
            builder: (c,snapshot){
              Map dataMap ;
              if(snapshot.hasData){
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    AdminStatusBanner(status: dataMap[EcommerceApp.isSuccess],),
                    SizedBox(height: 10,),
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
                      future: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                          .doc(orderBy)
                          .collection(EcommerceApp.subCollectionAddress).doc(addressID).get(),
                      builder: (c,snap){
                        return snap.hasData
                            ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data()),)
                            : Center(child: circularProgress(),);
                      },
                    ),
                  ],
                ),
              )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final  bool status ;

  AdminStatusBanner({Key key , this.status}): super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg ;
    IconData iconData ;
    status ? iconData = Icons.done : iconData = Icons.cancel ;
    status ? msg = "Successfully" : msg= "UnSuccessfully" ;
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


class AdminShippingDetails extends StatelessWidget {
  final AddressModel model ;

  AdminShippingDetails({Key key,this.model}) : super(key: key);

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
              message: 'Confirm',
              onPressed:() {
                confirmParcel(context,getOrderId);
              } ,
            ),
          ),
        ),
      ],
    );
  }
  confirmParcel(BuildContext context,String myOrderId ){
    EcommerceApp.firestore.collection(EcommerceApp.collectionOrders)
        .doc(myOrderId).delete();
    getOrderId = "" ;
    Route route = MaterialPageRoute(builder: (c)=>UploadPage());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: "Order has been Confirmed");
  }
}


