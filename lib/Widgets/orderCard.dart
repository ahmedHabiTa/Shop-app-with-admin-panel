import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Orders/OrderDetailsPage.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/order_provider.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatefulWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
    final int numberOfOrder ;
  OrderCard({this.itemCount, this.data, this.orderID,this.numberOfOrder});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
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
              Text('Order : ${widget.numberOfOrder}',style: TextStyle(
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
                      itemCount: widget.itemCount,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (c, index) {
                        ItemModel model = ItemModel.fromJson(widget.data[index].data());
                        return sourceOrderInfo(model, context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green
                            ),
                            child: FlatButton(
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                    builder: (c) => OrderDetails(orderID: widget.orderID));
                                Navigator.pushReplacement(context, route);
                              },
                              child: Text('Details',style: TextStyle(color:  Colors.white),),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red[900]
                            ),
                            child: FlatButton(
                              onPressed: () => Provider.of<OrderProvider>(context, listen: false)
                              .deleteOrder(context, widget.orderID),
                              child: Text('Delete',style: TextStyle(color:  Colors.white),),
                            ),
                          ),
                        ),
                      ],
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

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  width = MediaQuery.of(context).size.width;
  var themeMode = Provider.of<ThemeProvider>(context).tm;
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product : ${model.title} ',
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.blue[900],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),maxLines: 2,
          ),
          Text(
            'price : ${(model.price).toString()} EGP',
            style: GoogleFonts.robotoCondensed(
              textStyle: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.blue[900],
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
