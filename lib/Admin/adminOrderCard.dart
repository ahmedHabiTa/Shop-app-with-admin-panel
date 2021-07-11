import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/adminOrderDetails.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/orderCard.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy ;
  final int numberOfOrder ;
  AdminOrderCard({this.numberOfOrder, this.itemCount, this.data, this.orderID, this.addressID, this.orderBy}) ;

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return  Card(
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      child:  Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('Order : $numberOfOrder',style: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.blue[900],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Container(
                    width: 250,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemCount,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (c, index) {
                        ItemModel model = ItemModel.fromJson(data[index].data());
                        return sourceOrderInfo(model, context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green
                        ),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => AdminOrderDetails(orderID: orderID,orderBy: orderBy,addressID: addressID));
                            Navigator.pushReplacement(context, route);
                          },
                          child: Text('Details',style: TextStyle(color:  Colors.white),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


