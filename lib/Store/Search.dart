import 'package:commerce/Models/item.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/myDrawer.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56, 56),
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
              itemCount: snap.data.docs.length,
              itemBuilder: (context, index) {
                ItemModel model =
                ItemModel.fromJson(snap.data.docs[index].data());
                return sourceInfo(model, context);
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

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 80,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0, 0),
            end: FractionalOffset(1, 0),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          )),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 40,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(hintText: 'Search....',hintStyle: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(color: Colors.black)
                  )),
                ),
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
