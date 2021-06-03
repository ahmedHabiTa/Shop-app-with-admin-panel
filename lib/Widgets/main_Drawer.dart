import 'package:commerce/Authentication/authenication.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Address/addAddress.dart';
import 'package:commerce/Store/Search.dart';
import 'package:commerce/Store/cart.dart';
import 'package:commerce/Orders/orders_screen.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/theme_settings.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Container(
      color: Colors.black,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 110,
                backgroundImage: NetworkImage(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userAvatarUrl)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
              style: GoogleFonts.actor(
                textStyle: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.blue[900],
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              textAlign: TextAlign.center,
            ),
             Divider(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black87,
                thickness: 1,
              ),
            Column(
              children: <Widget>[
                customListTile(themeMode,Icons.home,'Home',() {
                  Route route =
                  MaterialPageRoute(builder: (c) => StoreHome());
                  Navigator.pushReplacement(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode, Icons.reorder, 'My Orders', () {
                  Route route = MaterialPageRoute(builder: (c) => MyOrders());
                  Navigator.pushReplacement(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode, Icons.shopping_cart, 'My Cart', () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.push(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode, Icons.search, 'Search', () {
                  Route route =
                  MaterialPageRoute(builder: (c) => SearchProduct());
                  Navigator.pushReplacement(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode, Icons.add_location, 'Add new Address', () {
                  Route route =
                  MaterialPageRoute(builder: (c) => AddAddress());
                  Navigator.pushReplacement(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode, Icons.settings, 'Settings', () {
                  Route route =
                  MaterialPageRoute(builder: (c) => ThemesScreen());
                  Navigator.push(context, route);
                }),
                customDivider(themeMode),
                customListTile(themeMode,  Icons.exit_to_app, 'Log Out', () {
                  EcommerceApp.auth.signOut().then((c) {
                    Route route =
                    MaterialPageRoute(builder: (c) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                  });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customDivider(ThemeMode themeMode) {
    return Divider(
      height: 10,
      color: themeMode == ThemeMode.dark ? Colors.white60 : Colors.black38,
      thickness: 3,
      indent: 50,
      endIndent: 50,
    );
  }
  Widget customListTile(ThemeMode themeMode,IconData icon,String text,Function function){
    return ListTile(
      leading: Icon(
        icon,
        color: themeMode == ThemeMode.dark
            ? Colors.white
            : Colors.blue[900],
      ),
      title: Text(text,
        style: GoogleFonts.robotoCondensed(
          textStyle: TextStyle(
              color: themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.blue[900],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),),
      onTap: function
    );
  }
}
