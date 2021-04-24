import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/storehome.dart';

import 'package:commerce/Models/address.dart';
import 'package:commerce/Widgets/myDrawer.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0, 0),
                  end: FractionalOffset(1, 0),
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                )),
          ),
          title: Text(
            'Address',
            style: GoogleFonts.satisfy(
          textStyle: TextStyle(color: Colors.white, fontSize: 40)
        ),
          ),
          centerTitle: true,

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                      name: cName.text.trim(),
                      phoneNumber: cPhoneNumber.text.trim(),
                      city: cCity.text.trim(),
                      pincode: cPinCode.text.trim(),
                      flatNumber: cFlatNumber.text.trim(),
                      state: cState.text.trim())
                  .toJson();
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().toString())
                  .set(model)
                  .then((value) {
                final snack =
                    SnackBar(content: Text('New Address Added Successfully'),duration: Duration(seconds: 2),);
                // ignore: deprecated_member_use
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text('Done'),
          backgroundColor: Color.fromRGBO(255, 105, 150, 1),
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text('Add new Address',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    MyTextField(
                      hint: "Name :",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone number :",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Flat number :",
                      controller: cFlatNumber,
                    ),
                    MyTextField(
                      hint: "City :",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State / Country :",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code :",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    var tm = Provider.of<ThemeProvider>(context).tm;
    return Card(
      color: Color.fromRGBO(255, 254, 230, 0.5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration.collapsed(
            hintText: hint,
            hintStyle: TextStyle(
                color: tm == ThemeMode.dark ? Colors.white : Colors.black),
          ),
          validator: (value) => value.isEmpty ? "Field can not be empty" : null,
        ),
      ),
    );
  }
}
