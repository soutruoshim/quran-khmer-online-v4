import 'package:flutter/material.dart';
import 'package:quran_khmer_online/common_widget/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    height: 44.0,
    color: Colors.teal,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
