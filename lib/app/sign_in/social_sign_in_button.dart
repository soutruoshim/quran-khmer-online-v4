import 'package:flutter/material.dart';
import 'package:quran_khmer_online/common_widget/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required  String assetName,
    @required  String text,
    @required Color color,
    @required Color textColor,
    VoidCallback onPressed
  }) : assert(assetName != null),
       assert(text != null),
      super(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                //Image.asset(assetName),
                Icon(Icons.email_outlined, color: textColor,),
                Text(
                 text,
                  style: TextStyle(fontSize: 15.0, color: textColor),
                ),
                Opacity(
                  opacity: 0.0,
                  //child: Image.asset(assetName),
                  child: Icon(Icons.email_outlined),
                )
              ],
      ),
      color: color,
      borderRadius: 4.0,
      onPressed: onPressed
  );
}