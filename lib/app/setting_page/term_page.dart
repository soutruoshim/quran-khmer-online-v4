import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
class TermPage extends StatefulWidget {
  @override
  _TermPageState createState() => _TermPageState();
}
class _TermPageState extends State<TermPage> {
  String url = "http://www.islamic-forum-kh.com/app_privacy/quran_kh_online_term.html";
  bool isLoading=true;
  final _key = UniqueKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        elevation: 0.5,
      ),
      body: _buildContents(context)
    );
  }


  Widget _buildContents(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          key: _key,
          initialUrl: this.url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        isLoading ? Center( child: CircularProgressIndicator(),)
            : Stack(),
      ],
    );
  }
}