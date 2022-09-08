import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/home/home_page.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final user = snapshot.data;
            if(user == null){
              //return SignInPage();
              print("e");
              return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: "xxx"),
                child: HomePage(),
              );
            }
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage(),
            );
          }
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator()
              )
          );
        }
    );
  }
}
