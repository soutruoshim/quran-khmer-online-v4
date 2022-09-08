import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  //CustomRaisedButton({Key key, this.color, this.borderRadius, this.height, this.child}) : super(key: key);
  CustomRaisedButton({@required this.child, @required this.color, this.borderRadius:2.0,this.height:50.0, this.onPressed}):assert(borderRadius!=null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  VoidCallback onPressed;



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
          child: child,
          color: color,
          disabledColor: color,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          onPressed: onPressed
      ),
    );
  }
}
