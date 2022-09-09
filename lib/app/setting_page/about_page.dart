import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
          elevation: 0.5,
        ),
      body: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text('Quran Khmer Online', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.teal)),
                    SizedBox(height: 6,),
                    Container(height: 2, width: 230, color: Colors.teal),
                    SizedBox(height: 6,),
                    Text('Version 1.0.4', style: TextStyle(fontSize: 16, color: Colors.teal)),
                  ],
          ),
      )
    );
  }
}