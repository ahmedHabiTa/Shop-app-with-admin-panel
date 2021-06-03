import 'package:commerce/Models/item.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/main_Drawer.dart';
import 'package:commerce/providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;

    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: customAppBar(themeMode, context, 'Search',bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: searchBar(),
        )),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
              itemCount: snap.data.docs.length,
              itemBuilder: (context, index) {
                ItemModel model =
                ItemModel.fromJson(snap.data.docs[index].data());
                return productsInfo(model, context);
              },
            )
                : Center(
              child: Container(
                height: 100,
                child: Text('No products available...',
                  style: GoogleFonts.arsenal(
                      textStyle:  TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold
                  ),),),

            ),);
          },
        ),
      ),
    );
  }
Widget searchBar(){
  var mode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      margin: EdgeInsets.only(right: 10, left: 10),
      color: mode == ThemeMode.dark ? Colors.white : Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(1),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: mode == ThemeMode.dark
              ? Theme.of(context).canvasColor
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 18),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(hintText: 'Search...',hintStyle: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                          color: mode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
                          fontSize: 17)
                  )),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.search,
                color:
                mode == ThemeMode.dark ? Colors.white : Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
}

  Future startSearching(String query) async {
    docList = FirebaseFirestore.instance
        .collection('items')
        .where('shortInfo', isGreaterThanOrEqualTo: query)
        .get() ;
  }
}
