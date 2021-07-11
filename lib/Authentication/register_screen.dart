import 'package:commerce/Authentication/Authentication_provider.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Register extends StatelessWidget {
  final TextEditingController _nameController =  TextEditingController();
  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();
  final TextEditingController _confirmPasswordController =  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AuthenticationProvider>(
      builder: (context,provider,_){
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 8.0,
                ),
                InkWell(
                  onTap: provider.selectAndPickImage,
                  child: CircleAvatar(
                    radius: _screenWidth * 0.15,
                    backgroundColor: Colors.blue[900],
                    backgroundImage:
                    provider.imageFile == null ? null : FileImage( provider.imageFile),
                    child:  provider.imageFile == null
                        ? Icon(
                      Icons.add_photo_alternate,
                      size: _screenWidth * 0.15,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        controller: _nameController,
                        data: Icons.person,
                        hintText: 'name',
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        data: Icons.email,
                        hintText: 'E-mail',
                        isObsecure: false,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        data: Icons.lock,
                        hintText: 'Password',
                        isObsecure: true,
                      ),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        data: Icons.lock,
                        hintText: 'Confirm Password',
                        isObsecure: true,
                      ),
                    ],
                  ),
                ),
                WideButton(
                  message: 'Sign Up',
                  onPressed: () {
                    provider.uploadAndSaveImage(context, _passwordController.text, _confirmPasswordController.text, _emailController.text, _nameController.text);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }














}
