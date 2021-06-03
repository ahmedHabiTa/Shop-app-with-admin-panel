import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Orders/placeOrder.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/Counters/changeAddresss.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;

  Address({Key key, this.totalAmount});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(themeMode, context, 'Address'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Text('Select Address',
                        style: TextStyle(
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 20))),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(EcommerceApp.collectionUser)
                      .doc(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .collection(EcommerceApp.subCollectionAddress)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data.docs.length == 0
                            ? noAddressCard()
                            : ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return AddressCard(
                                    currentIndex: address.count,
                                    value: index,
                                    addressID: snapshot.data.docs[index].id,
                                    totalAmount: widget.totalAmount,
                                    model: AddressModel.fromJson(
                                        snapshot.data.docs[index].data()),
                                  );
                                },
                              );
                  },
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
          label: Text(
            'Add new Address',
            style: TextStyle(
                color: themeMode == ThemeMode.dark
                    ? Colors.black87
                    : Colors.white),
          ),
          backgroundColor:
              themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
          icon: Icon(Icons.add_location,
              color:
                  themeMode == ThemeMode.dark ? Colors.black87 : Colors.white),
        ),
      ),
    );
  }

  noAddressCard() {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Center(
      child: Card(
        semanticContainer: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark
                  ? Theme.of(context).canvasColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add_location,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.red[900],
                  size: 40,
                ),
                Text('No Address saved',
                    style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.red[900],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;

  final int currentIndex;

  final String addressID;

  final double totalAmount;
  final int value;

  AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.addressID,
      this.totalAmount,
      this.value});

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Provider.of<AddressChanger>(context, listen: false)
              .displayResult(widget.value);
        },
        splashColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Container(
            decoration: BoxDecoration(
              color: themeMode == ThemeMode.dark
                  ? Theme.of(context).canvasColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      groupValue: widget.currentIndex,
                      value: widget.value,
                      activeColor: themeMode == ThemeMode.dark
                          ? Colors.grey
                          : Colors.blue[900],
                      onChanged: (val) {
                        Provider.of<AddressChanger>(context, listen: false)
                            .displayResult(val);
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          width: screenWidth * 0.8,
                          child: Table(
                            children: [
                              TableRow(children: [
                                keyText("Name", context),
                                keyText(widget.model.name, context),
                              ]),
                              TableRow(children: [
                                keyText("Phone number", context),
                                keyText(widget.model.phoneNumber, context),
                              ]),
                              TableRow(children: [
                                keyText("Flat", context),
                                keyText(widget.model.flatNumber, context),
                              ]),
                              TableRow(children: [
                                keyText("City", context),
                                keyText(widget.model.city, context),
                              ]),
                              TableRow(children: [
                                keyText("State / Country", context),
                                keyText(widget.model.state, context),
                              ]),
                              TableRow(children: [
                                keyText("Pin Code", context),
                                keyText(widget.model.pincode, context),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                widget.value == Provider.of<AddressChanger>(context).count
                    ? WideButton(
                        message: "Proceed",
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (c) => PaymentPage(
                                  addressID: widget.addressID,
                                  totalAmount: widget.totalAmount));
                          Navigator.pushReplacement(context, route);
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget keyText(String msg, context) {
  var themeMode = Provider.of<ThemeProvider>(context).tm;
  return Text(
    msg,
    style: TextStyle(
        color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold),
  );
}
