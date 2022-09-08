import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/sign_in/email_signin_page.dart';
import 'package:quran_khmer_online/app/sign_in/email_signup_page.dart';
import 'package:quran_khmer_online/app/sign_in/sign_in_button.dart';
import 'package:quran_khmer_online/app/sign_in/social_sign_in_button.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;


  void _showSignInError(BuildContext context, Exception exception){
    if(exception is FirebaseException && exception.code== 'ERROR_ABORTED_BY_USER'){
      return;
    }
    showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async{
    try{
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    }on Exception catch(e){
      _showSignInError(context, e);
    }finally{
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    }on Exception catch(e){
      _showSignInError(context, e);
    }finally{
      setState(() => _isLoading = false);
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EmailSignInPage(),
        )
    );
  }
  void _signUpWithEmail(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => EmailSignUpPage(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        elevation: 0.5,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.white70,
    );
  }

  Widget _buildContent(BuildContext context){
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Container(
        //   decoration: new BoxDecoration(
        //       image: new DecorationImage(
        //           fit: BoxFit.cover,
        //           image: AssetImage("images/background.png"),
        //           //image: new NetworkImage('https://i.pinimg.com/originals/ee/6f/a9/ee6fa90da8af4affa10737d312591035.jpg')
        //    )
        //   ),
        //
        // ),

        Positioned(
          bottom: 48.0,
          left: 10.0,
          right: 10.0,
          child: Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                    child: _buildHeader(),
                  ),
                  // SizedBox(
                  //   height: 8.0,
                  // ),
                  // SocialSignInButton(
                  //   assetName: 'images/google-logo.png',
                  //   text: "Sign in with google",
                  //   color: Colors.white,
                  //   textColor: Colors.black87,
                  //   onPressed:
                  //       _isLoading ? null : () => _signInWithGoogle(context),
                  // ),
                  SizedBox(
                    height: 8.0,
                  ),
                  SocialSignInButton(
                    assetName: 'images/email.png',
                    text: "Sign in with email",
                    color: Colors.white,
                    textColor: Colors.black87,
                    onPressed:
                        _isLoading ? null : () => _signInWithEmail(context),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  SignInButton(
                    text: "Sign in with Guest",
                    color: Colors.lime,
                    textColor: Colors.black87,
                    onPressed:
                    _isLoading ? null : () => _signInAnonymously(context),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildOr(),
                  SizedBox(
                    height: 30.0,
                  ),
                  SocialSignInButton(
                    assetName: 'images/email.png',
                    text: "Sign Up with Email",
                    color: Colors.teal,
                    textColor: Colors.white,
                    onPressed:
                    _isLoading ? null : () => _signUpWithEmail(context),
                  ),

                  SizedBox(height: 60.0),
                  // Text(
                  //   "Copyright © 2021-2022",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.tealAccent),
                  // ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  _buildOr(){
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.black87,
            height: 8.0,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(
          'OR',
          style: TextStyle(color: Colors.black87),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Divider(
            color: Colors.black87,
            height: 8.0,
          ),
        )
      ],
    );
  }


  _buildHeader() {
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
    );
  }
}

