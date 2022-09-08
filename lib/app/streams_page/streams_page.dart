import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/streams_page/account_list_tile.dart';
import 'package:quran_khmer_online/app/streams_page/list_items_builder.dart';
import 'package:quran_khmer_online/common_widget/show_message_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:math';

class StreamsPage extends StatefulWidget {
  //TextEditingController controller;
  @override
  _StreamsPageState createState() => _StreamsPageState();
}
class _StreamsPageState extends State<StreamsPage> {
  String searchKeyWord = '';
  bool isAudioOnly = false;
  bool isAudioMuted = false;
  bool isVideoMuted = false;

  var subjectString = "Quran Teaching";
  var nameString = "Sout Rahim";
  var emailString = "sout.rahim@email.com";

  var iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");

  //KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  var keyboardVisibilityController = KeyboardVisibilityController();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;

  _joinMeeting(Account account) async {
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (Platform.isAndroid) {
      // Disable ConnectionService usage on Android to avoid issues (see README)
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      // Disable PIP on iOS as it looks weird
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: account.id)
      ..subject = subjectString
      ..userDisplayName = nameString
      ..userEmail = emailString
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags);

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keyboardState = keyboardVisibilityController.isVisible;
    //
    // _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
    //   onChange: (bool visible) {
    //     setState(() {
    //       _keyboardState = visible;
    //     });
    //   },
    // );
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _keyboardState = visible;
      });
    });
    _getCurrentUserInfo();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));

  }
  Widget _getCurrentUserInfo(){
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    if(auth.currentUser == null){
      return Text("");
    }
    return  StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('');
          } else {
            final userDocument = snapshot.data;
            if (userDocument != null) {
              subjectString = userDocument.name;
              nameString = userDocument.name;
              emailString = userDocument.email;
              return Text('');
            }else{
              String guest = generateRandomString(6);
              subjectString = guest;
              nameString = guest;
              emailString = guest+"@gmail.com";
              return Text('');
            }
          }
        }
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  Future<void> setOnline(String status) async{
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .update({'online': status});
    } on Exception catch (e) {
      print(e);
    }


  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
    //_keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);

  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    setOnline('online');
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    setOnline('ofline');
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }
  // getUserData() async{
  //   DocumentSnapshot userdoc = await userCollection.doc(FirebaseAuth.instance.currentUser.uid).get();
  //   setState(() {
  //     username = userdoc.data()['username'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming'),
        elevation: 0.5,
        actions: <Widget>[
          actionStream()
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: _buildTextSearch()
              ,)
        ),
      ),

      body: _buildContents(context),
    );
  }

  Widget actionStream(){
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    if(auth.currentUser == null){
      return Text('');
    }
    return  StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          //print(snapshot.data.name);
          if (snapshot.hasError) {
            return Text('');
          } else {
            //print(snapshot.data);
            final userDocument = snapshot.data;
            if (userDocument != null) {
              subjectString = userDocument.name;
              nameString = userDocument.name;
              emailString = userDocument.email;
              if(userDocument.role == 'teacher'){
                return IconButton(
                  icon: Icon(Icons.video_call, color: Colors.white),
                  onPressed: () {
                    _joinMeeting(userDocument);
                  },
                );
              }
              return Text('');
            }else{
              return Text('');
            }
          }
        }
    );
  }

  final controller = TextEditingController();

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(4.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Search', border: InputBorder.none
            ),
            onChanged: (val) {
              setState(() {
                searchKeyWord = val;
              });
            },

          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
      ),
    );
  }


  Widget _buildTextSearch(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, color: Colors.black54),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(4.0),
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon:GestureDetector(
            child: Container(
              child: controller.text.length > 0? Icon(Icons.cancel):Text(''),
            ),onTap: () {
            controller.clear();
            setState(() {
              searchKeyWord = '';
            });
          },
          ),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
        onChanged: (val) {
          setState(() {
            searchKeyWord = val;
            //print('search: $searchKeyWord');
          });
        },
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Account>>(
      stream: database.searchAccountsStream(searchKeyWord),
      builder: (context, snapshot) {
        return ListItemsBuilder<Account>(
            snapshot: snapshot,
            itemBuilder: (context, account) {
              return AccountListTile(
                  account: account,
                  onTap: () {},
                  onCall:(){
                    if(account.online == 'online'){
                      _joinMeeting(account);
                    }else{
                      showMessageDialog(
                          context,
                          title: 'Message',
                          message : 'The teacher not yet on stream.');
                    }
                  }
              );
            }
        );
      },
    );
  }
}
