import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/quran_page/models/ayat.dart';
import 'package:quran_khmer_online/app/quran_page/models/surah.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:quran_khmer_online/app/quran_page/widgets/item_ayah.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({@required this.surah});
  final Surah surah;

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {

  Surah item;
  @override
  void initState() {
    super.initState();
    item = widget.surah;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.centerLeft,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5.0),
                //   color: Colors.teal.shade300,
                // ),
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Text(
              "${item.name}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 21.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(CupertinoIcons.search, color: Colors.grey),
        //   ),
        //   SizedBox(width: 10.0),
        // ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              toolbarHeight: 260.0,
              title: Container(
                height: 250.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "images/vector.png"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Surah ${item.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 26.0,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "${item.translatedEn}",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Divider(
                        indent: 40,
                        endIndent: 40,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "${item.place} - ${item.count} ayat",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        height: 48.0,
                        width: 214.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item.id != 9?"images/bismillah.png":"images/empty.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: ayatItems(name: ""),
      ),
    );
  }

  Widget ayatItems({String name = ""}) {
    return FutureBuilder(
      future: ReadJsonData(),
      builder: (context, data) {
        if (data.hasError) {
          //in case if error found
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
          var items = data.data as List<Ayat>;
          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 20.0),
              itemCount: items == null ? 0 : items.length,
              itemBuilder: (context, index) {
                     return ItemAyah(item:items[index]);
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

  // Widget itemAyah(Ayat ayat){
  //
  // }

  Future<List<Ayat>> ReadJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('jsonfile/translate.json');
    final list = json.decode(jsondata) as List<dynamic>;
    final list_all = list.map((e) => Ayat.fromJson(e)).toList();
   // print(list_all);
    final list_ayat = list_all.where((element) => element.suraId == widget.surah.id.toString()).toList();
    return list_ayat;
    //return list.map((e) => Ayat.fromJson(e)).toList();
  }

}
