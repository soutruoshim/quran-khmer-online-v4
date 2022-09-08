import 'package:flutter/material.dart';
import 'package:quran_khmer_online/app/home/cupertino_home_scaffold.dart';
import 'package:quran_khmer_online/app/home/tab_item.dart';
import 'package:quran_khmer_online/app/quran_page/quran_page.dart';
import 'package:quran_khmer_online/app/schedule_page/schedule_page.dart';
import 'package:quran_khmer_online/app/streams_page/streams_page.dart';
import 'package:quran_khmer_online/app/account_page/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.streams;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.streams: GlobalKey<NavigatorState>(),
    TabItem.schedules: GlobalKey<NavigatorState>(),
    TabItem.quran: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.streams: (_) => StreamsPage(),
      TabItem.schedules: (context) => SchedulePage(),
      TabItem.quran: (context) => QuranPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem){
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
