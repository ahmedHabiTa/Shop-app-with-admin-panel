 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/adminLogin.dart';
 import 'package:commerce/Widgets/customTextField.dart';
 import 'package:commerce/DialogBox/errorDialog.dart';
 import 'package:commerce/DialogBox/loadingDialog.dart';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import '../Store/storehome.dart';
 import 'package:commerce/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/login.png'),
              height: 240,
              width: 240,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Login to your account',style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _emailController ,
                    data: Icons.email,
                    hintText: 'E-mail',
                    isObsecure: false ,
                  ),
                  CustomTextField(
                    controller: _passwordController ,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true ,
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: (){
               _emailController.text.isNotEmpty &&_passwordController.text.isNotEmpty ?
                   loginUser()
                   : showDialog(context: context,builder: (c){
                     return ErrorAlertDialog(message: 'Please Enter your Email and Password',);
               });
              },
              color: Colors.pink,
              child: Text('Login',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 50,),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(height: 10,),
            // ignore: deprecated_member_use
            FlatButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage())),
                icon: Icon(Icons.nature_people,color: Colors.pink,),
                label: Text('Admin ? Login here !',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async{
    showDialog(context: context,builder: (c){
      return LoadingAlertDialog(message: 'Logging, Please wait.....',);
    });
    User firebaseUser ;
    await _auth.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim()
    ).then((authUser) {
      firebaseUser = authUser.user ;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,builder: (c){
        return ErrorAlertDialog(message: error.message.toString(),);
      });
    });
    if(firebaseUser != null){
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c)=>StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }
  Future readData(User fUser)async{
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString("uid",dataSnapshot[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,dataSnapshot[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot[EcommerceApp.userAvatarUrl]);
      List<String> cartList = dataSnapshot[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
    } );
  }
}
