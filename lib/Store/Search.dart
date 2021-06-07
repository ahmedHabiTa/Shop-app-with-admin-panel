import 'package:commerce/Models/item.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/main_drawer.dart';
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
 // Future<QuerySnapshot> docList;

var queryResultSet = [];
var tempSearchStore = [];
initialSearch(value){
  if(value.length == 0){
    setState(() {
      queryResultSet = [];
      tempSearchStore = [];
    });
  }
  var capitalizedValue = value.substring(0,1).toUpperCase() + value.substring(1);
  if(queryResultSet.length ==0 && value.length ==1){
searchByName(value).then((QuerySnapshot documents){
  for(int i = 0;i<documents.docs.length;++i){
    queryResultSet.add(documents.docs[i].data());
  }
});
  }else{
    tempSearchStore=[];
    queryResultSet.forEach((element) {
      if(element['shortInfo'].startsWith(capitalizedValue)){
        setState(() {
          tempSearchStore.add(element);
        });
      }
    });
  }
}
  searchByName(String searchField)  {
    return  FirebaseFirestore.instance
        .collection('items')
        .where('searchKey', isEqualTo: searchField.substring(0,1).toUpperCase())
        .get();
  }
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;

    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: customAppBar(themeMode, context, 'Search',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: searchBar(),
            )),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 4,
          childAspectRatio: 1/1.8,
          primary: false,
          shrinkWrap: true,
          children: tempSearchStore.map((element) {
            ItemModel itemModel =ItemModel.fromJson(element);
            return productsInfo(itemModel, context);
          } ).toList(),
        ),
      ),
    );
  }

  Widget searchBar() {
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
                   if(value.isEmpty){
                     // ignore: unnecessary_statements
                     (){};
                   }else{
                     initialSearch(value);
                   }
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: 'Search...',
                      hintStyle: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                              color: mode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.blue[900],
                              fontSize: 17))),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.search,
                color: mode == ThemeMode.dark ? Colors.white : Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
