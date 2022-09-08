import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/sign_in/email_sign_up_form.dart';

class EmailSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: EmailSignUpForm(),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}