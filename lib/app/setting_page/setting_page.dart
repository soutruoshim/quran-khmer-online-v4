import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/account_page/account_page.dart';
import 'package:quran_khmer_online/app/landing_page.dart';
import 'package:quran_khmer_online/app/lecture_page/lectures_page.dart';
import 'package:quran_khmer_online/app/schedule_set_page/sechedule_set_page.dart';
import 'package:quran_khmer_online/app/setting_page/setting_list_item.dart';
import 'package:quran_khmer_online/app/setting_page/size_config.dart';
import 'package:quran_khmer_online/app/sign_in/sign_in_page.dart';
import 'package:quran_khmer_online/common_widget/avatar.dart';
import 'package:quran_khmer_online/common_widget/show_alert_dialog.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  File _image;


  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  String _name     = '';
  String _role     = '';
  String _email    = '';
  String _phone    = '';
  String _province = '';
  String _img      = '';
  String _online   = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init homepage");

  }

  Future<void> _signOut(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> _deleteAccount(BuildContext context) async{
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.deleteAccount();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Delete Account',
      content: 'Are you sure that you want to delete account?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Yes',
    );
    if (didRequestSignOut == true) {
      _deleteAccount(context);
    }
  }
  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }


  Future<void> _submit(BuildContext context) async{

    if(_validateAndSaveForm()) {
      try {

        final auth = Provider.of<AuthBase>(context, listen: false);
        final database = Provider.of<Database>(context, listen: false);

        final id = auth.currentUser.uid;
        final account = Account(id,
            _name, _role, _email, _phone, _province, _img, _online
        );
        await database.setAccount(account).whenComplete(() {setState(() {

        });});

      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
            context, title: 'Operand Failed', exception: e);
      }
    }
  }

  _rateApp() {
    //LaunchReview.launch(iOSAppId: IOS_APP_ID);
    print("yu");
  }

  _shareApp() {
    // try {
    //   if (UniversalPlatform.isAndroid) {
    //     Share.share('$SHARE_TEXT \n $ANDROID_SHARE_URL');
    //   } else if (UniversalPlatform.isIOS) {
    //     Share.share('$SHARE_TEXT \n $IOS_SHARE_URL');
    //   }
    // } catch (e) {
    //   print(e);
    // }
    print("yu");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          elevation: 0.5,
        ),
        body: _body(context),
    );
  }

  _body(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                _buildUserImage(context),
                SizedBox(height: SizeConfig.blockSizeVertical),
                _buildUserName(context),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                _buildScreenButtonsList(context),
                _buildBottomScreenButtonsList(context),
                _buildLogoutAndDeleteList(context),
                SizedBox(height: SizeConfig.blockSizeVertical * 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildUserImage(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    if(auth.currentUser == null){
      return CircleAvatar(
        backgroundImage: AssetImage('images/user_icon.png'),
        backgroundColor: Colors.transparent,
        maxRadius: SizeConfig.blockSizeHorizontal * 9.5,
      );
    }
    return StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(
              backgroundImage: AssetImage('images/user_icon.png'),
              backgroundColor: Colors.transparent,
              maxRadius: SizeConfig.blockSizeHorizontal * 9.5,
            );
          } else {
            final userDocument = snapshot.data;
            if (userDocument != null) {
              _name = userDocument.name;
              _img = userDocument.img;
              return CircleAvatar(
                backgroundImage: NetworkImage(
                  _img,
                ),
                backgroundColor: Colors.transparent,
                maxRadius: SizeConfig.blockSizeHorizontal * 9.5,
              );
            }else{
              return Center(
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 4.0,
                ),
              );
            }
          }
        }
    );
  }

  _buildUserName(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    if (auth.currentUser == null || auth.currentUser == null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountPage()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: SizeConfig.blockSizeHorizontal * 5,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal),
            Text(
              'Login/Sign up',
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4.2,
              ),
            ),
          ],
        ),
      );
    }
    return  StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else {
            final userDocument = snapshot.data;
            if (userDocument != null) {
              _name = userDocument.name;
              _img = userDocument.img;
              return Text(
                _name,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                ),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 4.0,
                ),
              );
            }
          }
        }
    );
  }
  _buildScreenButtonsList(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return _buttonsListContainer(
      context,
      Column(
        children: [
          auth.currentUser == null || auth.currentUser == null
              ? Container()
              : SettingsListItem(
              text: 'Edit Profile',
              arrow: true,
              first: true,
              // onTap: () => Navigator.pushNamed(
              //     context, EditProfileScreen.routeName),
              onTap:(){

              }
          ),
          auth.currentUser == null || auth.currentUser == null
              ? Container()
              : SettingsListItem(
              text: 'Messages',
              arrow: true,
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (ctx) => ConversationsScreen()),
              // ),
              onTap:(){

              }
          ),

          SettingsListItem(
            text: 'Share the app',
            arrow: false,
            onTap: () => _shareApp(),
          ),
          SettingsListItem(
            text: 'Rate this app',
            arrow: false,
            onTap: () => _rateApp(),
          ),
        ],
      ),
    );
  }
  _buttonsListContainer(BuildContext context, Widget body) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 10.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white10,
            width: 1.0),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:Color(0xFFCFDCE7),
            blurRadius: 0.5,
            offset: Offset(0.2, 0.2),
          ),
        ],
      ),
      child: body,
    );
  }

  _buildBottomScreenButtonsList(BuildContext context) {
    return  Container(
        child: _buttonsListContainer(
          context,
          Column(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              SettingsListItem(
                text: 'About Us',
                arrow: true,
                first: true,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) => InformationScreen(title: 'About Us'),
                //   ),
                // ),
              ),
              SettingsListItem(
                text: 'Contact Us',
                arrow: true,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) => InformationScreen(title: 'Contact Us'),
                //   ),
                // ),
              ),
              SettingsListItem(
                text: 'FAQ',
                arrow: true,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) => InformationScreen(title: 'FAQ'),
                //   ),
                // ),
              ),
              SettingsListItem(
                text: 'Privacy Policy',
                arrow: true,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) =>
                //         InformationScreen(title: 'Privacy Policy'),
                //   ),
                // ),
              ),
              SettingsListItem(
                text: 'Terms and Conditions',
                arrow: true,
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (ctx) =>
                //         InformationScreen(title: 'Terms and Conditions'),
                //   ),
                // ),
              ),
            ],
          ),
        ),
    );
  }

  _buildLogoutAndDeleteList(BuildContext context) {
        final auth = Provider.of<AuthBase>(context, listen: false);
        if (auth.currentUser != null && auth.currentUser != null) {
          return Container(
            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
            child: _buttonsListContainer(
              context,
              Column(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  auth.currentUser == null || auth.currentUser == null
                      ? Container()
                      : SettingsListItem(
                    text: 'Logout',
                    arrow: true,
                    first: true,
                    color: Theme.of(context).primaryColor,
                    onTap: () => _confirmSignOut(context),
                  ),
                  auth.currentUser == null || auth.currentUser == null
                      ? Container()
                      : SettingsListItem(
                    text: 'Delete Account',
                    arrow: false,
                    color: Colors.red,
                    onTap: () => _confirmDeleteAccount(context),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Delete Account':
        _confirmDeleteAccount(context);
        break;
      case 'Logout':
        _confirmSignOut(context);
        break;
      case 'Lectures':
        final database = Provider.of<Database>(context, listen: false);
        Lecture_Page.show(context);
        break;
      case 'Schedule':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Schedule_Set_Page()),
        );
        break;
    }
  }
}
