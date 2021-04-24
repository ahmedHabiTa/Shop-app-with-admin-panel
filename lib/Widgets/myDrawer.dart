import 'package:commerce/Authentication/authenication.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Address/addAddress.dart';
import 'package:commerce/Store/Search.dart';
import 'package:commerce/Store/cart.dart';
import 'package:commerce/Orders/myOrders.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/theme_settings.dart';
import 'package:flutter/material.dart';



class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            )
            ),
            child: Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),style: TextStyle(color: Colors.white,fontSize: 35,),),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Container(
            padding: EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.lightGreenAccent],
                  begin: const FractionalOffset(0, 0),
                  end: FractionalOffset(1, 0),
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                )
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home,color: Colors.white,),
                  title: Text('Home',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.reorder,color: Colors.white,),
                  title: Text('My Orders',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart,color: Colors.white,),
                  title: Text('My Cart',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.search,color: Colors.white,),
                  title: Text('Search',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.add_location,color: Colors.white,),
                  title: Text('Add new Address',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> AddAddress());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.settings,color: Colors.white,),
                  title: Text('Settings',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=> ThemesScreen());
                      Navigator.pushReplacement(context, route);

                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 6,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app,color: Colors.white,),
                  title: Text('Log Out',style: Theme.of(context).textTheme.headline1),
                  onTap: (){
                    EcommerceApp.auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
