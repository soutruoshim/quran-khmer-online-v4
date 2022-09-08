import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/common_widget/app_color.dart';
import 'package:quran_khmer_online/models/schedule.dart';

class ScheduleListTile extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onTap;
  const ScheduleListTile({Key key, this.schedule, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // child: Text(
        //   _getInitials(schedule.lecture),
        //   style: TextStyle(color: Colors.white, fontSize: 18),
        // ),
        // backgroundColor: _getAvatarColor(schedule.lecture),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: CachedNetworkImage(
            imageUrl: schedule.img,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),),
      ),
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.lecture,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.timelapse_sharp,
            color: Colors.teal,
            size: 18.0,
          ),
          Text(" "),
          Text(
            schedule.start_time,
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
          Text(" - "),
          Text(
            schedule.end_time,
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }

  Color _getAvatarColor(String user) {
    return AppColors
        .avatarColors[user.hashCode % AppColors.avatarColors.length];
  }
}

//calls[index].video==true?Icons.video_call:Icons.call,color: Color(0xFF25D366),
