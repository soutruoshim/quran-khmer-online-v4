import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quran_khmer_online/app/schedule_set_page/schedule_set_day.dart';

class Schedule_Set_Page extends StatefulWidget {
  @override
  _Schedule_Set_PageState createState() => _Schedule_Set_PageState();
}
class _Schedule_Set_PageState extends State<Schedule_Set_Page> {
  List<String> item = ["Monday","Tuesday","Wednesday","Thursday",
    "Friday", "Saturday", "Sunday"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        elevation: 0.5,
      ),
      body: _buildContents(context),
    );
  }


  Widget _buildContents(BuildContext context) {
    return ListView.builder(
      itemCount: item.length,
      itemBuilder: (context, pos) {
        return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Schedule_Set_Day(day_num: (pos + 1).toString())),
              );
            },
            child:Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Text(item[pos], style: TextStyle(
                  fontSize: 16.0,
                  height: 1.6,
                ),),
              ),
            )
        ));
      },
    );
  }
}
