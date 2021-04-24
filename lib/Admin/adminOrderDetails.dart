import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Address/check_out_address.dart';
import 'package:commerce/Admin/uploadItems.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/orderCard.dart';
import 'package:commerce/Models/address.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


import 'adminShiftOrders.dart';

String getOrderId = "";
class AdminOrderDetails extends StatelessWidget {
  final String orderID ;
  final String orderBy ;
  final String addressID ;

  AdminOrderDetails({Key key,this.orderID, this.orderBy, this.addressID}): super (key:key);

  @override
  Widget build(BuildContext context) {
    getOrderId =orderID ;
    return SafeArea(
      child: Scaffold(
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
                    AdminStatusBanner(status: dataMap[EcommerceApp.isSuccess],),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('\$ ' + dataMap[EcommerceApp.totalAmount].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Order ID' + getOrderId),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Ordered at :' + DateFormat("dd MMMM,yyyy - hh:mm aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap['orderTime']))),
                        style: TextStyle(color: Colors.grey,fontSize: 16),
                      ),
                    ),
                    Divider(height: 2,),
                    FutureBuilder<QuerySnapshot>(
                      future: EcommerceApp.firestore.collection('items')
                          .where('shortInfo',whereIn: dataMap[EcommerceApp.productID]).get(),
                      builder: (c,dataSnapshot){
                        return dataSnapshot.hasData
                            ? OrderCard(
                          itemCount: dataSnapshot.data.docs.length,
                          data:  dataSnapshot.data.docs,
                        )
                            : Center(child: circularProgress(),);
                      },
                    ),
                    Divider(height: 2,),
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
          IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c)=>AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            },
          ),
          SizedBox(width: 20,),
          Text("Order shipped "+ msg,style: TextStyle(color: Colors.white),),
          SizedBox(width: 5,),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(iconData,color: Colors.white,size: 14,),
            ),
          ),
        ],
      ),
    );
  }
}


class AdminShippingDetails extends StatelessWidget {
  final AddressModel model ;

  AdminShippingDetails({Key key,this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width ;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Shipment Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90,vertical: 5),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                  children: [
                    KeyText(msg: "Name",),
                    Text(model.name),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Phone number",),
                    Text(model.phoneNumber),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Flat",),
                    Text(model.flatNumber),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "City",),
                    Text(model.city),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "State / Country",),
                    Text(model.state),
                  ]
              ),
              TableRow(
                  children: [
                    KeyText(msg: "Pin Code",),
                    Text(model.pincode),
                  ]
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: (){
                confirmParcel(context,getOrderId);
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
                  child: Text('Confirmed',style: TextStyle(color: Colors.white,fontSize: 15),),
                ),
              ),
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


