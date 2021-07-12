import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/Widgets/main_drawer.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    var themeMode = Provider.of<ThemeProvider>(context).tm ;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: customAppBar(themeMode, context, "Address"),
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
          label: Text('Done',style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white),),
          backgroundColor:  themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
          icon: Icon(Icons.check,color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white,),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text('Add new Address',
                    style: TextStyle(
                        color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],fontSize: 18),),
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

  MyTextField({ this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(
                    color: themeMode == ThemeMode.dark ? Colors.white : Colors.black),
              ),
              validator: (value) => value.isEmpty ? "Field can not be empty" : null,
            ),
          ),
        ),
      ),
    );
  }
}
