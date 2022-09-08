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

  Future imgFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if(_image != null){
          uploadImageToFirebase(_image);
        }
      } else {
        print('No image selected.');
      }
    });
  }


  Future<void> uploadImageToFirebase(image) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child("image_" + auth.currentUser.uid);
    UploadTask uploadTask = ref.putFile(image);
    String imgUrl = await (await uploadTask).ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser.uid)
        .update({'img': imgUrl});
    setState(() {

    });
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    if(auth.currentUser == null){
      //return SignInPage();
      return SignInPage();
    }
    final email = auth.currentUser.email;
    var menu ={'Delete Account','Logout'};
    if(email == 'admin_qurankhmer_online@gmail.com'){
      menu = {'Lectures', 'Schedule', 'Logout'};
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Account"),
          elevation: 0.5,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return menu.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: _body(context),


    );
  }

  _body(BuildContext context) {
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
    return  StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildMoreInformation(context);
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

    // return InkWell(
    //   onTap: () => _navigateToAuthorProfile(context),
    //   child: Consumer<AuthProvider>(builder: (context, auth, child) {
    //     if (auth.user == null || auth.user.avatar == null) {
    //       return CircleAvatar(
    //         backgroundImage: AssetImage('assets/images/user_icon.png'),
    //         backgroundColor: Colors.transparent,
    //         maxRadius: SizeConfig.blockSizeHorizontal * 9.5,
    //       );
    //     } else {
    //       return CircleAvatar(
    //         backgroundImage: NetworkImage(
    //           auth.user.avatar,
    //         ),
    //         backgroundColor: Colors.transparent,
    //         maxRadius: SizeConfig.blockSizeHorizontal * 9.5,
    //       );
    //     }
    //   }),
    // );
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
              'Login',
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
            return _buildMoreInformation(context);
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
      margin: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white10,
            width: 1.0),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:Color(0xFFCFDCE7),
            blurRadius: 3.0,
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
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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

  Widget _accountContainer(){
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    return  StreamBuilder<Account>(
        stream: database.accountStream(accountId: auth.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildMoreInformation(context);
          } else {
            final userDocument = snapshot.data;
            if (userDocument != null) {
              _name = userDocument.name;
              _role = userDocument.role;
              _email = userDocument.email;
              _phone = userDocument.phone;
              _province = userDocument.province;
              _img = userDocument.img;
              return _buildMoreInformation(context);
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

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoURL,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
      ],
    );
  }
  _buildForm() {
    return Form(
        key: _formKey,
        child: _buildFormChildren()
    );
  }
  _buildFormChildren(){
    return
      Padding(
        padding: EdgeInsets.only(
            left: 0.0, right: 0.0, top: 0.0),
        child:  Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                        ),
                        enabled: !_status,
                        autofocus: !_status,
                        initialValue: _name,
                        validator: (value) => value.isNotEmpty? null: 'Name can\'t be empty',
                        onSaved: (value) => _name = value,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Email ID',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter Email ID"),
                        enabled: !_status,
                        keyboardType: TextInputType.emailAddress,
                        initialValue: _email,
                        validator: (value) => value.isNotEmpty? null: 'Email can\'t be empty',
                        onSaved: (value) => _email = value,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Mobile',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter Mobile Number"),
                        enabled: !_status,
                        keyboardType: TextInputType.phone,
                        initialValue: _phone,
                        validator: (value) => value.isNotEmpty? null: 'Phone\'t be empty',
                        onSaved: (value) => _phone = value,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 25.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Province',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter Province"),
                        enabled: !_status,
                        initialValue: _province,
                        validator: (value) => value.isNotEmpty? null: 'Province\'t be empty',
                        onSaved: (value) => _province = value,
                      ),
                    ),
                  ],
                )),
            // Padding(
            //     padding: EdgeInsets.only(
            //         left: 25.0, right: 25.0, top: 25.0),
            //     child: new Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Expanded(
            //           child: Container(
            //             child: new Text(
            //               'Pin Code',
            //               style: TextStyle(
            //                   fontSize: 16.0,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //           flex: 2,
            //         ),
            //         Expanded(
            //           child: Container(
            //             child: new Text(
            //               'State',
            //               style: TextStyle(
            //                   fontSize: 16.0,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //           flex: 2,
            //         ),
            //       ],
            //     )),

            // Padding(
            //     padding: EdgeInsets.only(
            //         left: 25.0, right: 25.0, top: 2.0),
            //     child: new Row(
            //       mainAxisSize: MainAxisSize.max,
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Flexible(
            //           child: Padding(
            //             padding: EdgeInsets.only(right: 10.0),
            //             child: new TextField(
            //               decoration: const InputDecoration(
            //                   hintText: "Enter Pin Code"),
            //               enabled: !_status,
            //             ),
            //           ),
            //           flex: 2,
            //         ),
            //         Flexible(
            //           child: new TextField(
            //             decoration: const InputDecoration(
            //                 hintText: "Enter State"),
            //             enabled: !_status,
            //           ),
            //           flex: 2,
            //         ),
            //       ],
            //     )),
          ],
        ),
      );

  }
  _buildMoreInformation(BuildContext context){
    print('image $_img');
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 180.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: (_img == '')? DecorationImage(
                                      image: new ExactAssetImage('images/as.png'),
                                      fit: BoxFit.cover,
                                    ): new DecorationImage(
                                        image: new NetworkImage(_img),
                                        fit: BoxFit.fill)
                                )),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 120.0),
                            child:  _name == ''?Text(""): new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => imgFromGallery(),
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 16.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Parsonal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                      _buildForm(),
                      !_status ? _getActionButtons(context) : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget _getActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new FlatButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed: () {
                      _submit(context);
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new FlatButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.orange,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.orange,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
