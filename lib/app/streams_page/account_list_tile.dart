import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/models/account.dart';

class AccountListTile extends StatelessWidget {

  final Account account;
  final VoidCallback onTap;
  final VoidCallback onCall;

  const AccountListTile({Key key, this.account, this.onTap, this.onCall}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  ListTile(
      // leading:
      // Container(
      //   height: 55,
      //   width: 55,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(40),
      //     child: CachedNetworkImage(
      //       imageUrl: account.img,
      //       imageBuilder: (context, imageProvider) => Container(
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             image: imageProvider,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       placeholder: (context, url) => CircularProgressIndicator(),
      //       errorWidget: (context, url, error) => Icon(Icons.error),
      //     ),
      //   ),
      // ),
      leading: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: Offset(0, 5),
                blurRadius: 25)
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                    imageUrl: account.img,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),)
            ),
             account.online =='online'
                ? Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(left: 20.0),
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
      title: Text(
        account.name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.phone, color:  Colors.teal,
            size: 16.0,
          ),
          Text(
            account.phone,
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
      trailing: InkWell(
        child: Icon(
              Icons.videocam_rounded,color: account.online == 'online'? Color(0xFF25D366):Color(
              0xFF8E8E8E),
         ),
          onTap: onCall,
        ),
        onTap: onCall,
    );
  }
}
//calls[index].video==true?Icons.video_call:Icons.call,color: Color(0xFF25D366),