import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/models/schedule.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../schedule_page/list_items_builder.dart';

class EditSchedulePage extends StatefulWidget {

  final Schedule schedule;
  final String day_num;

  const EditSchedulePage({Key key, this.schedule, this.day_num}) : super(key: key);

  static Future<void> show(BuildContext context, {Schedule schedule, String day_num}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditSchedulePage(schedule: schedule, day_num: day_num),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditSchedulePageState createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  String _start_time;
  String _end_time;
  String _lecture;
  String _lecture_id;
  String _img;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _start_time = widget.schedule.start_time;
      _end_time = widget.schedule.end_time;
      _lecture = widget.schedule.lecture;
      _lectureController.text = _lecture;
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

  Future<void> _submit() async {
    print('lecture value:'+ _lecture);
    if (_validateAndSaveForm()) {
      try {
          print(widget.day_num);
          FirestoreDatabase database = FirestoreDatabase(uid: "1234");
          final id = widget.schedule?.id ?? documentIdFromCurrentDate();
          print(id);
          final schedule = Schedule(id, _start_time, _end_time,_lecture_id, _lecture, _img);
          await database.setSchedule(schedule,widget.day_num, id);
          Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(widget.schedule == null ? 'New Schedule' : 'Edit Schedule'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildForm(context),
            //child: selectLeccture(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(context),
      ),
    );
  }
  var _lectureController = TextEditingController();
  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      selectLeccture(context),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture'),
        //initialValue: _lecture??"",
        keyboardType: TextInputType.text,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lecture = value,
        controller: _lectureController,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'Start Time'),
        initialValue: _start_time,
        keyboardType: TextInputType.datetime,
        validator: (value) => value.isNotEmpty ? null : 'Start can\'t be empty',
        onSaved: (value) => _start_time = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'End Time'),
        initialValue: _end_time,
        keyboardType: TextInputType.datetime,
        validator: (value) => value.isNotEmpty ? null : 'Start can\'t be empty',
        onSaved: (value) => _end_time = value,
      ),
    ];
  }
  var _mySelection;
  List<Account> items = [];
  Widget selectLeccture(BuildContext context) {
    final database = FirestoreDatabase(uid: '1234');
    print("before working");
    return StreamBuilder<List<Account>>(
      stream: database.searchAccountsStream(''),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const CircularProgressIndicator();
        // }
        //print(snapshot.data);
        items = snapshot.data;
        return SizedBox(
          width: 240,
          child: DropdownButtonFormField(
              items: items
                  .map((item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 18),
                  )))
                  .toList(),
              //value: selectedItem,
              onChanged: (value) {
                print('selected:'+value);
                setLectureName(items, value);
              }),
        );
        return Container();
      },
    );
  }
  void setLectureName(List<Account> accounts,
      String id) {
    // Return list of people matching the condition
    final account = accounts.where((element) =>
    element.id == id);

    if (account.isNotEmpty) {
      print('Using where: ${account.first.name}');
      setState(() {
         _lecture = account.first.name;
         _lecture_id = id;
         _lectureController.text = account.first.name;
         _img = account.first.img;
      });
    }
  }
}
