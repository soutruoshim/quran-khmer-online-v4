import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/schedule_page/custom_dialog_box.dart';
import 'package:quran_khmer_online/app/schedule_page/list_items_builder.dart';
import 'package:quran_khmer_online/app/schedule_page/schedule_list_tile.dart';
import 'package:quran_khmer_online/models/schedule.dart';
import 'package:quran_khmer_online/services/database.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  List<bool> _selectDate = [true, true, true, true,true, true,true];
  List<String> _day = ["Mo", "Tu", "We", "Th","Fr", "Sa","Su"];
  List<String> _day_full = ["Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday","Sunday"];
  var day_num = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currDt = DateTime.now();
    print(currDt.year); // 4
    print(currDt.weekday); // 4
    print(currDt.month); // 4
    print(currDt.day); // 2
    print(currDt.hour); // 15
    print(currDt.minute); // 21
    print(currDt.second); // 49

    var index =  currDt.weekday.toInt();
    setCurrentDay(index-1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        elevation: 0.5,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: _buildWeekDay(context)
              ,)
        ),

      ),
      body: _buildContents(context),
    );
  }



  _buildWeekDay(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) => _weekItem(index)),
      ),
    );
  }

  _buildContents(BuildContext context){
    final database = FirestoreDatabase(uid: '1234');
    return StreamBuilder<List<Schedule>>(
      stream: database.scheduleDayStream(day_num.toString()),
      builder: (context, snapshot) {
        return ListItemsBuilder<Schedule>(
          snapshot: snapshot,
          itemBuilder: (context, schedule) {
            return ScheduleListTile(
              schedule: schedule ,
              onTap: () {
                showDialog(context: context,
                    builder: (BuildContext context){
                      return CustomDialogBox(
                        title: schedule.lecture,
                        descriptions: "He will online stream on "+_day_full[day_num - 1] +" at time: "+schedule.start_time + " to "+schedule.end_time,
                        text: "Ok",
                        img: schedule.img,
                      );
                    }
                );
              },
            );
          }
        );
      },
    );
  }

  void setCurrentDay(index){
    setState(() {
      _selectDate[index] = false;
      for(var i =0 ; i < _selectDate.length; i++ ){
        if(i != index){
          _selectDate[i] = true;
        }
      }
      day_num = index + 1;
    });
  }
  _weekItem(int index){
    return Container(
        child:Column(
          children: [
            InkWell(
              onTap: (){
                 setCurrentDay(index);
              },
              child: Container(
                decoration: _selectDate[index]? null: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(_day[index], style: TextStyle(fontWeight: FontWeight.w600,color: _selectDate[index]?Colors.black54:Colors.white),),
                  Container(
                    margin: EdgeInsets.only(top: 4.0),
                    width: 4.0,
                    height: 4.0,
                    decoration: _selectDate[index]?null: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                  )
                ],),
              ),
            )
          ],
        )
    );
  }

}
