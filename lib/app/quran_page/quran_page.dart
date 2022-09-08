import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:quran_khmer_online/app/quran_page/db_helper/sql_helper.dart';
import 'package:quran_khmer_online/app/quran_page/models/surah.dart';
import 'package:quran_khmer_online/app/quran_page/surah_page.dart';
import 'package:quran_khmer_online/app/quran_page/widgets/listItemWidget.dart';
import 'package:flutter/services.dart' as rootBundle;

class QuranPage extends StatefulWidget {
  const QuranPage({Key key}) : super(key: key);

  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  String searchText = "";
  List<Map<String, dynamic>> _bookmarkList = [];
  bool _isLoading = false;
  List<Surah> surahList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshBookmark();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Quran"),
          elevation: 0.5,
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                // SliverAppBar(
                //   //toolbarHeight: 190.0,
                //   backgroundColor: Colors.teal,
                //   automaticallyImplyLeading: false,
                //   title: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //      Text(
                //           'Quran',
                //           style: TextStyle(
                //             color: Colors.white
                //           ),
                //         ),
                //       Container(
                //         height: 120.0,
                //         margin: EdgeInsets.only(top: 18.0),
                //         padding: EdgeInsets.all(25.0),
                //         alignment: Alignment.bottomLeft,
                //         decoration: BoxDecoration(
                //           color: Colors.grey.shade200,
                //           borderRadius: BorderRadius.circular(10.0),
                //           image: DecorationImage(
                //             image: AssetImage("images/quran_bg.png"),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         child: Text(
                //           "Suralar",
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 23.0,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SliverAppBar(
                  toolbarHeight: 150.0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130.0,
                        margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                        padding: EdgeInsets.all(25.0),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage("images/quran_bg2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          "Al-Quran",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverAppBar(
                  backgroundColor: Colors.grey.shade100,
                  elevation: 0.0,
                  toolbarHeight: 70.0,
                  pinned: true,
                  title: Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        border: InputBorder.none,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 18.0,
                        ),
                        hintText: "Search surah",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onChanged: (value){
                           setState(() {
                                searchText = value;
                           });
                      }, //_search,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size(100.0, 40.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: TabBar(
                          dragStartBehavior: DragStartBehavior.down,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          //labelColor: Color.fromRGBO(197, 162, 110, 1),
                          labelColor: Colors.teal,
                          unselectedLabelColor: Colors.grey.shade400,
                          //indicatorColor: Color.fromRGBO(197, 162, 110, 1),
                          indicatorColor: Colors.teal,
                          indicatorWeight: 3.0,
                          tabs: [
                            Tab(text: 'Surah'),
                            Tab(text: 'Bookmarks'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                chapters(name: searchText),
                ayahBookmarks(),
              ],
            ),
          ),
        ),
      );
  }

  Widget chapters({String name = ""}) {
    return FutureBuilder(
      future: ReadJsonData(),
      builder: (context, data) {
        if (data.hasError) {
          //in case if error found
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
          var items = data.data as List<Surah>;
          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (context, index) {
                surahList.add(items[index]);
                print(name);
                if(name == ""){
                  return ListItemWidget(item: items[index]);
                }else{
                  if(items[index].name.toLowerCase().contains(name.toLowerCase()) || items[index].translatedAr.contains(name)){
                    return ListItemWidget(item: items[index]);
                  }
                }
              });
        } else {
          // show circular progress while data is getting fetched from json file
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future _refreshBookmark() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _bookmarkList = data;
      _isLoading = false;
    });
  }
  Widget ayahBookmarks_temp() {
    return _isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : ListView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: _bookmarkList.length,
      itemBuilder: (context, index) => Column(
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
                          "${_bookmarkList[index]['verseId']}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap:()=> share(_bookmarkList[index]),
                              child:Icon(Icons.share_outlined, color: Colors.grey,)
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                              onTap:(){
                                Clipboard.setData(ClipboardData(text: "${_bookmarkList[index]['ayahText']} \n ${_bookmarkList[index]['ayahTextKhmer']}"));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Ayat copied"),
                                ));
                              },
                              child:Icon(Icons.copy, color: Colors.grey,)
                          ),
                          SizedBox(width: 15.0),
                          GestureDetector(
                            onTap:()=> _deleteItem(_bookmarkList[index]['ayah_id']),
                            child:Icon(CupertinoIcons.bookmark_fill, color: Colors.grey,)
                          )

                          // IconButton(
                          //     padding: new EdgeInsets.all(0.0),
                          //     onPressed: ()=> _deleteItem(_bookmarkList[index]['ayah_id']), icon: Icon(
                          //     CupertinoIcons.bookmark_fill, color: Colors.grey)
                          // )
                          ,
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0),
                InkWell(
                  onTap: (){
                    final surah = surahList[int.parse(_bookmarkList[index]['suraId'])];
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurahPage(surah: surah,)));
                  },
                  child: Text('سورة '+
                    _bookmarkList[index]['surahName'],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 26.0,
                        color: Colors.teal,
                        fontFamily: "osman"
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  _bookmarkList[index]['ayahText'],
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
              _bookmarkList[index]['ayahTextKhmer'],
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
        ),
    );
  }
  Widget ayahBookmarks() {
    return _isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        :
    RefreshIndicator(
      onRefresh: _refreshBookmark,
      backgroundColor: Colors.teal,
      color: Colors.white,
      displacement: 200,
      strokeWidth: 5,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: _bookmarkList.length,
        itemBuilder: (context, index) => Column(
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
                          "${_bookmarkList[index]['verseId']}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap:()=> share(_bookmarkList[index]),
                              child:Icon(Icons.share_outlined, color: Colors.grey,)
                          ),
                          SizedBox(width: 20.0),
                          GestureDetector(
                              onTap:(){
                                Clipboard.setData(ClipboardData(text: "${_bookmarkList[index]['ayahText']} \n ${_bookmarkList[index]['ayahTextKhmer']}"));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("Ayat copied."),
                                ));
                              },
                              child:Icon(Icons.copy, color: Colors.grey,)
                          ),
                          SizedBox(width: 15.0),
                          GestureDetector(
                              onTap:()=> _deleteItem(_bookmarkList[index]['ayah_id']),
                              child:Icon(CupertinoIcons.bookmark_fill, color: Colors.grey,)
                          )

                          // IconButton(
                          //     padding: new EdgeInsets.all(0.0),
                          //     onPressed: ()=> _deleteItem(_bookmarkList[index]['ayah_id']), icon: Icon(
                          //     CupertinoIcons.bookmark_fill, color: Colors.grey)
                          // )
                          ,
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0),
                InkWell(
                  onTap: (){
                    final surah = surahList[int.parse(_bookmarkList[index]['suraId']) - 1];
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurahPage(surah: surah,)));
                  },
                  child: Text('سورة '+
                      _bookmarkList[index]['surahName'],
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 34.0,
                        color: Colors.teal,
                        fontFamily: "surah_family"
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  _bookmarkList[index]['ayahText'],
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
              _bookmarkList[index]['ayahTextKhmer'],
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
        ),
      ),
    );
  }

  Future<List<Surah>> ReadJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('jsonfile/chapter_list.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Surah.fromJson(e)).toList();
  }
  void _deleteItem(String id) async {
    await SQLHelper.deleteItem(id);
    _refreshBookmark();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Bookmark has been removed.'),
    ));
  }
  Future<void> share(item) async {
    await FlutterShare.share(
        title: '${item['surahName']}',
        text: "${item['ayahText']} \n ${item['ayahTextKhmer']}"
    );
  }

}
