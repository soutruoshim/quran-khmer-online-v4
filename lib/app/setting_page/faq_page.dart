import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/setting_page/models/faq_model.dart';

class FaqPage extends StatefulWidget {
  @override
  State<FaqPage> createState() => _FaqPageState();
}


class _FaqPageState extends State<FaqPage> {
  List<Menu> data = [];

  @override
  void initState() {
    dataList.forEach((element) {
      data.add(Menu.fromJson(element));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ'),
          elevation: 0.5,
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) =>
              _buildList(data[index]),
        ),
    );
  }

  // Widget _drawer (List<Menu> data){
  //   return Drawer(
  //       child: SafeArea(
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               UserAccountsDrawerHeader(margin: EdgeInsets.only(bottom: 0.0),
  //                   accountName: Text('demo'), accountEmail: Text('demo@webkul.com')),
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 itemCount: data.length,
  //                 itemBuilder:(context, index){return _buildList(data[index]);},)
  //             ],
  //           ),
  //         ),
  //       ));
  // }

  Widget _buildList(Menu list) {
    if (list.subMenu.isEmpty)
      return Builder(
          builder: (context) {
            return ListTile(
                //onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategory(list.name))),
                leading: SizedBox(),
                title: Text(list.name)
            );
          }
      );
    return ExpansionTile(
      leading: Icon(list.icon),
      title: Text(
        list.name,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: list.subMenu.map(_buildList).toList(),
    );
  }
}

