import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';

class EditLecturePage extends StatefulWidget {
  const EditLecturePage({Key key, this.database, this.account})
      : super(key: key);

  final Database database;
  final Account account;

  static Future<void> show(BuildContext context,
      {Database database, Account account}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditLecturePage(database: database, account: account),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditLecturePageState createState() => _EditLecturePageState();
}

class _EditLecturePageState extends State<EditLecturePage> {
  final _formKey = GlobalKey<FormState>();
  int _radioValue1 = -1;
  String _name = '';
  String _role = '';
  String _email = '';
  String _phone = '';
  String _province = '';
  String _img = '';
  String _online = '';

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _name = widget.account.name;
      _role = widget.account.name;
      _email = widget.account.email;
      _phone = widget.account.phone;
      _img = widget.account.img;
      _province = widget.account.province;
      if(widget.account.role != 'teacher'){
        _radioValue1 = 1;
      }else{
        _radioValue1 = 0;
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    if (_validateAndSaveForm()) {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        final database = Provider.of<Database>(context, listen: false);
        final id = auth.currentUser.uid;
        final account =
            Account(id, _name, _role, _email, _phone, _province, _img, _online);
        await database.setAccount(account);
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operand Failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('Update Lecture'),
        // actions: <Widget>[
        //   FlatButton(
        //     child: Text(
        //       'Save',
        //       style: TextStyle(fontSize: 18, color: Colors.white),
        //     ),
        //     //onPressed: _submit,
        //   ),
        // ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(children: [
              new Container(
                height: 180.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: (_img == '')? DecorationImage(
                                      image: new ExactAssetImage('images/as.png'),
                                      fit: BoxFit.cover,
                                    ): new DecorationImage(
                                        image: new NetworkImage(_img),
                                        fit: BoxFit.fill)
                                )),
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              _buildForm(),
            ],)

          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      new ListTile(
          leading: const Icon(
            Icons.person,
            color: Colors.teal,
          ),
          title: Column(
            children: [
              new TextField(
                controller: TextEditingController(text: _name),
                readOnly : true,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Name"),
              ),
              const Divider(
                height: 1.0,
              ),
            ],
          )),
      new ListTile(
          leading: const Icon(
            Icons.email,
            color: Colors.teal,
          ),
          title: Column(
            children: [
              new TextField(
                readOnly : true,
                controller: TextEditingController(text: _email),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Name"),
              ),
              const Divider(
                height: 1.0,
              ),
            ],
          )),
      new ListTile(
          leading: const Icon(
            Icons.phone,
            color: Colors.teal,
          ),
          title: Column(
            children: [
              new TextField(
                readOnly : true,
                controller: TextEditingController(text: _phone),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Name"),
              ),
              const Divider(
                height: 1.0,
              ),
            ],
          )),
      new ListTile(
          leading: const Icon(
            Icons.map,
            color: Colors.teal,
          ),
          title: Column(
            children: [
              new TextField(
                readOnly : true,
                controller: TextEditingController(text: _province),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Name"),
              ),
              const Divider(
                height: 1.0,
              ),
            ],
          )),
      new ListTile(
          leading: const Icon(
            Icons.security,
            color: Colors.teal,
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Teacher',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Student',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          )),

      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Lecture Name'),
      //   readOnly: true,
      //   initialValue: _name,
      //   validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      //   onSaved: (value) => _name = value,
      // ),
      // TextFormField(
      //   readOnly: true,
      //   decoration: InputDecoration(labelText: 'Email ID'),
      //   initialValue: _email != null ? '$_email' : null,
      //   keyboardType: TextInputType.numberWithOptions(
      //     signed: false,
      //     decimal: false,
      //   ),
      //   onSaved: (value) => _email = value,
      // ),
      // TextFormField(
      //   readOnly: true,
      //   decoration: InputDecoration(labelText: 'Phone'),
      //   initialValue: _phone != null ? '$_phone' : null,
      //   keyboardType: TextInputType.numberWithOptions(
      //     signed: false,
      //     decimal: false,
      //   ),
      //   onSaved: (value) => _phone = value,
      // ),
    ];
  }
  void _handleRadioValueChange1(int value) {
    setState(() {

      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          updateRole('teacher');
          Fluttertoast.showToast(msg: 'Change to teacher !',toastLength: Toast.LENGTH_SHORT);

          break;
        case 1:
          updateRole('student');
          Fluttertoast.showToast(msg: 'Change to student !',toastLength: Toast.LENGTH_SHORT);
          break;
      }
    });
  }
  Future<void> updateRole(String role) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.account.id)
          .update({'role': role});
    } on Exception catch (e) {
      print(e);
    }
  }

}
