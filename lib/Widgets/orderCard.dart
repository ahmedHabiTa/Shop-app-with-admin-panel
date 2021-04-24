import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Orders/OrderDetailsPage.dart';
import 'package:commerce/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({Key key, this.itemCount, this.data, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent[100], Colors.redAccent[200]],
              begin: const FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            )),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height:  (itemCount * 50.0)+30,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  width = MediaQuery.of(context).size.width;

  return SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Product name : ${model.title} ',
                style: GoogleFonts.robotoCondensed(
                    textStyle:  TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
              ),
              ),
              Text(
                'price : \$ ${(model.price).toString()}',
                style: GoogleFonts.robotoCondensed(
                  textStyle:  TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),



  );
}
