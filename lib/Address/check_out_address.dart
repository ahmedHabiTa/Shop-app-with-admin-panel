import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/address.dart';
import 'package:commerce/Orders/placeOrder.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addAddress.dart';

class Address extends StatefulWidget
{
  final double totalAmount;

  Address({Key key ,this.totalAmount}): super (key: key);

  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Select Address',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
              Consumer<AddressChanger>(builder: (context,address,c){
                return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                        .collection(EcommerceApp.subCollectionAddress).snapshots(),

                    builder: (context,snapshot){
                      return !snapshot.hasData
                          ? Center(child: circularProgress(),)
                          : snapshot.data.docs.length == 0
                          ? noAddressCard()
                          : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                                return AddressCard(
                                  currentIndex:  address.count,
                                  value: index,
                                  addressID: snapshot.data.docs[index].id,
                                  totalAmount: widget.totalAmount ,
                                  model: AddressModel.fromJson(snapshot.data.docs[index].data()),
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
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c)=>AddAddress());
                Navigator.pushReplacement(context, route);
              },
              label: Text('Add new Address'),
              backgroundColor: Colors.pink,
              icon: Icon(Icons.add_location),),
        ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_location,color: Colors.white,),
            Text('No Address saved'),
            Text('please add your Address'),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model ;
  final int  currentIndex ;
  final String addressID ;
  final double totalAmount;
  final int value ;


  AddressCard({Key key,this.model, this.currentIndex, this.addressID, this.totalAmount,
    this.value}) : super(key : key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width ;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context,listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.pink.withOpacity(0.4),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val){
                    Provider.of<AddressChanger>(context,listen: false).displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenWidth* 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name",),
                              Text(widget.model.name),
                            ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Phone number",),
                                Text(widget.model.phoneNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Flat",),
                                Text(widget.model.flatNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "City",),
                                Text(widget.model.city),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "State / Country",),
                                Text(widget.model.state),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Pin Code",),
                                Text(widget.model.pincode),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ? WideButton(message: "Proceed",
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c)=> PaymentPage(addressID : widget.addressID,totalAmount: widget.totalAmount));
                Navigator.pushReplacement(context, route);
               },)
                : Container(),
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {
final String msg ;

KeyText({Key key,this.msg}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
    );
  }
}
