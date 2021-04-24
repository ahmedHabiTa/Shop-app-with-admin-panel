import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/uploadItems.dart';
import 'package:commerce/Authentication/authenication.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'E-Shopping',
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: const FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/admin.png'),
              height: 240,
              width: 240,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Admin',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _adminIDController ,
                    data: Icons.person,
                    hintText: 'Admin ID ',
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
            SizedBox(height: 25,),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: (){
                _adminIDController.text.isNotEmpty &&_passwordController.text.isNotEmpty ?
                loginAdmin()
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
            SizedBox(height: 20,),
            // ignore: deprecated_member_use
            FlatButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthenticScreen())),
                icon: Icon(Icons.nature_people,color: Colors.pink,),
                label: Text('if not Admin,Please return to the login Page !',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
  loginAdmin(){
    FirebaseFirestore.instance.collection('admins').get().then((snapshot){
      snapshot.docs.forEach((result){
        if(result['id'] != _adminIDController.text.trim()){
            // ignore: deprecated_member_use
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid ID'),));
        }
        else if(result['password'] != _passwordController.text.trim()){
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid Password'),));
        }else{
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome dear Admin,'+result['name']),));
          setState(() {
            _adminIDController.text = '';
            _passwordController.text = '';
          });
          Route route = MaterialPageRoute(builder: (c)=>UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
