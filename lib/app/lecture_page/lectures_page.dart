import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/lecture_page/account_list_tile.dart';
import 'package:quran_khmer_online/app/lecture_page/edit_lecture_page.dart';
import 'package:quran_khmer_online/app/lecture_page/list_items_builder.dart';
import 'package:quran_khmer_online/common_widget/show_alert_dialog.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/common_widget/show_message_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/services/database.dart';

class Lecture_Page extends StatefulWidget {
  final Database database;

  const Lecture_Page({Key key, this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => Lecture_Page(database: database),
      ),
    );
  }

  @override
  _Lecture_PageState createState() => _Lecture_PageState();
}

class _Lecture_PageState extends State<Lecture_Page> {
  String searchKeyWord = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
        elevation: 0.5,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.add, color: Colors.white),
        //     onPressed: () => EditLecturePage().show(
        //       context,
        //       database: Provider.of<Database>(context, listen: false),
        //     ),
        //   ),
        // ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: _buildTextSearch()
              ,)
        ),
      ),
      body: _buildContents(context),
    );
  }
  Future<void> _delete(BuildContext context, Account account) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteAccount(account);

    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  TextEditingController controller = TextEditingController();

  Widget _buildTextSearch(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.black54),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon:GestureDetector(
            child: Container(
              child: controller.text.length > 0? Icon(Icons.cancel):Text(''),
            ),onTap: () {
            controller.clear();
            setState(() {
              searchKeyWord = '';
            });
          },
          ),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
        onChanged: (val) {
          setState(() {
            searchKeyWord = val;
            //print('search: $searchKeyWord');
          });
        },
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Account>>(
      stream: database.searchAllAccountsStream(searchKeyWord),
      builder: (context, snapshot) {
        return ListItemsBuilder<Account>(
          snapshot: snapshot,
          itemBuilder: (context, account) => Dismissible(
            key: Key('job-${account.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, account),
            child: AccountListTile(
              account: account,
              onTap: () => EditLecturePage.show(context, account: account),
            ),
          ),
        );
      },
    );
  }
}
