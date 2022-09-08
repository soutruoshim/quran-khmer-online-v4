import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/quran_page/models/surah.dart';
import 'package:quran_khmer_online/app/quran_page/surah_page.dart';
import 'borderNumber.dart';

class ListItemWidget extends StatefulWidget {
  const ListItemWidget({ @required this.item});
  final Surah item;

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: BorderNumber(number: widget.item.id),
      ),
      title: Text(widget.item.name, style: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      subtitle: Text("${widget.item.place} - ${widget.item.count} ayat"),
      trailing: Text(widget.item.translatedAr ,textAlign: TextAlign.end, style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'surah_family',
          //color: Color.fromRGBO(163, 129, 80, 1),
          color: Colors.teal,
          fontSize: 34.0),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurahPage(surah: widget.item,)));
      },
    );
  }
}
