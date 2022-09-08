import 'package:meta/meta.dart';
class Account{

  Account(@required this.id,
      @required this.name,
      @required this.role,
      @required this.email,
      @required this.phone,
      @required this.province,
      @required this.img,
      @required this.online
      );

  final String id;
  final String name;
  final String role;
  final String email;
  final String phone;
  final String province;
  final String img;
  final String online;


  factory Account.fromMap(Map<String, dynamic> data, String documentId) {
    // if (data == null) {
    //   return null;
    // }

    final String name = data['name'];
    final String role = data['role'];
    final String email= data['email'];
    final String phone = data['phone'];
    final String province = data['province'];
    final String img =data['img'];
    final String online = data['online'];

    return Account(documentId,name,role, email, phone, province, img, online);
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'province': province,
      'img': img,
      'online': online
    };
  }
}