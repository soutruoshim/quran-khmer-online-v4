import 'package:meta/meta.dart';
class Schedule{

  Schedule(@required this.id,
      @required this.start_time,
      @required this.end_time,
      @required this.lecture_id,
      @required this.lecture,
      @required this.img,
      );

  final String id;
  final String start_time;
  final String end_time;
  final String lecture_id;
  final String lecture;
  final String img;


  factory Schedule.fromMap(Map<String, dynamic> data, String documentId) {
    // if (data == null) {
    //   return null;
    // }

    final String start_time = data['start_time'];
    final String end_time = data['end_time'];
    final String lecture_id= data['lecture_id'];
    final String lecture= data['lecture'];
    final String img= data['img'];


    return Schedule(documentId,start_time,end_time,lecture_id, lecture, img);
  }

  Map<String, dynamic> toMap(){
    return {
      'start_time': start_time,
      'end_time': end_time,
      'lecture_id': lecture_id,
      'lecture': lecture,
      'img': img
    };
  }
}