import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_khmer_online/app/quran_page/db_helper/sql_helper.dart';
import 'package:quran_khmer_online/app/quran_page/models/ayat.dart';
import 'package:flutter_share/flutter_share.dart';

class ItemAyah extends StatefulWidget {
  const ItemAyah({ @required this.item});
  final Ayat item;

  @override
  _ItemAyahState createState() => _ItemAyahState();
}

class _ItemAyahState extends State<ItemAyah> {
  var bookmark = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getItem(widget.item.id);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                //color: Color.fromRGBO(163, 129, 80, 0.1),
                color: Color.fromRGBO(128, 203, 196, 0.1),

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 16.0,
                    child: Text(
                      "${widget.item.verseId}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                          onTap:()=> share(),
                          child:Icon(Icons.share_outlined, color: Colors.grey,)
                      ),
                      SizedBox(width: 20.0),
                      GestureDetector(
                          onTap:(){
                            Clipboard.setData(ClipboardData(text: "${widget.item.ayahText} \n ${widget.item.ayahTextKhmer}"));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Ayat copied"),
                          ));
                          },
                          child:Icon(Icons.copy, color: Colors.grey,)
                      ),
                      SizedBox(width: 15.0),
                      GestureDetector(
                      onTap:()=> bookmark?_deleteItem(widget.item.id):_addItem(),
                      child:Icon(bookmark?CupertinoIcons.bookmark_fill: CupertinoIcons.bookmark, color: Colors.grey,)
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              //subString(widget.item),
              //widget.item.ayahText,
              widget.item.verseId == "1"?subString(widget.item):widget.item.ayahText,

              textAlign: TextAlign.end,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                  color: Colors.black,
                  fontFamily: "osman"
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          widget.item.ayahTextKhmer,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: "khmeros"
          ),
        ),
        SizedBox(height: 10.0),
        Divider(
          height: 10,
          thickness: 2.0,
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
  Future<void> share() async {
    await FlutterShare.share(
        title: '${widget.item.surahName}',
        text: "${widget.item.ayahText} \n ${widget.item.ayahTextKhmer}"
    );
  }
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        widget.item.id,
        widget.item.suraId,
        widget.item.verseId,
        widget.item.ayahText,
        widget.item.ayahTextKhmer,
        widget.item.ayahNormal,
        widget.item.surahName);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Bookmark has been added.'),
    ));
    setState(() {
      bookmark = true;
    });
  }
  void _deleteItem(String id) async {
    await SQLHelper.deleteItem(id);
    setState(() {
        bookmark = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Bookmark has been removed.'),
    ));
  }

  void _getItem(String id) async {
    final data = await SQLHelper.getItem(id);
    if(data.isNotEmpty){
       setState(() {
           bookmark = true;
       });
    }
  }
  String subString(Ayat item){
    String cut = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
    if(item.suraId!= "1" && item.ayahText.contains(cut)){
      //print(item.ayahText.substring(cut.length));
      return item.ayahText.substring(cut.length);
    }
    return item.ayahText;
  }
}
