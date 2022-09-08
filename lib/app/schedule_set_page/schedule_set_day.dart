import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/schedule_set_page/edit_schedule_page.dart';
import 'package:quran_khmer_online/app/schedule_set_page/list_items_builder.dart';
import 'package:quran_khmer_online/app/schedule_set_page/schedule_list_tile.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/schedule.dart';
import 'package:quran_khmer_online/services/database.dart';

class Schedule_Set_Day extends StatelessWidget {

  final day_num;

  const Schedule_Set_Day({Key key, this.day_num}) : super(key: key);

  Future<void> _delete(BuildContext context, Schedule schedule) async {
    try {
        FirestoreDatabase database = FirestoreDatabase(uid: "1234");
        await database.deleteSchedule(day_num, schedule);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditSchedulePage.show(
              context,
              day_num: day_num,
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = FirestoreDatabase(uid: '1234');
    return StreamBuilder<List<Schedule>>(
      stream: database.scheduleDayStream(day_num),
      builder: (context, snapshot) {
        return ListItemsBuilder<Schedule>(
          snapshot: snapshot,
          itemBuilder: (context, schedule) => Dismissible(
            key: Key('job-${schedule.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, schedule),
            child: ScheduleListTile(
              schedule: schedule ,
              onTap: () => EditSchedulePage.show(context, day_num:day_num, schedule: schedule ),
            ),
          ),
        );
      },
    );
  }
}
