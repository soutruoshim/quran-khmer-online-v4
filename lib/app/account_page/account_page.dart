import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quran_khmer_online/app/landing_page.dart';
import 'package:quran_khmer_online/app/lecture_page/lectures_page.dart';
import 'package:quran_khmer_online/app/schedule_set_page/sechedule_set_page.dart';
import 'package:quran_khmer_online/app/sign_in/sign_in_page.dart';
import 'package:quran_khmer_online/common_widget/avatar.dart';
import 'package:quran_khmer_online/common_widget/show_alert_dialog.dart';
import 'package:quran_khmer_online/common_widget/show_exception_alert_dialog.dart';
import 'package:quran_khmer_online/models/account.dart';
import 'package:quran_khmer_online/services/auth.dart';
import 'package:quran_khmer_online/services/database.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin{
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

  // Future<void> getImage() async {
  //   var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //
  //   int rand = new Math.Random().nextInt(100000);
  //   Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  //   Img.Image smallerImg = Img.copyResize(image, width: 250, height: 250);
  //   var compressImg = new File("$path/image_$rand.jpg")
  //   ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 80));
  //
  //   setState(() {
  //     _image = compressImg;
  //     if(_image != null){
  //       uploadImageToFirebase(_image);
  //     }
  //      print('Image Path $_image');
  //
  //   });
  // }

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
    // uploadTask.then((res) {
    //   var url =  res.ref.getDownloadURL();
    //   print("url");
    //   print(url);
    //
    // });
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
          // actions: [
          //   TextButton(
          //       onPressed: () => _confirmSignOut(context),
          //       child: Text(
          //         "Logout",
          //         style: TextStyle(color: Colors.white, fontSize: 15.0),
          //       )),
          //   TextButton(
          //       onPressed: () => _confirmSignOut(context),
          //       child: Text(
          //         "Logout",
          //         style: TextStyle(color: Colors.white, fontSize: 15.0),
          //       ))
          // ],
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(130),
          //   child: _buildUserInfo(auth.currentUser),
          // ),
        ),
        body: _accountContainer()


    );
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
