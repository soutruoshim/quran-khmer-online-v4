import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quran_khmer_online/models/account.dart';

class AccountListTile extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  const AccountListTile({Key key, this.account, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 55,
        width: 55,
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
          ),
        ),
      ),
      title: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.phone,
            color: Colors.teal,
            size: 16.0,
          ),
          Text(
            account.phone,
            style: TextStyle(color: Colors.black54, fontSize: 15),
          ),
        ],
      ),
      trailing: Text(account.role, style: TextStyle(
          color: account.role != 'teacher'
              ? Color(0xFF8E8E8E)
              : Color(0xFF009688),
          fontSize: 15)),
      onTap: onTap,
    );
  }
}

//calls[index].video==true?Icons.video_call:Icons.call,color: Color(0xFF25D366),
