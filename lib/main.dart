import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/landing_page.dart';
import 'package:quran_khmer_online/services/auth.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
          title: "Quran Khmer Online",
          theme: ThemeData(
              primarySwatch: Colors.teal
          ),
          home: LandingPage(),
          debugShowCheckedModeBanner: false,
      ),
    );
  }
}