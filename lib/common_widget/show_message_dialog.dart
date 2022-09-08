import 'package:flutter/material.dart';
import 'package:quran_khmer_online/common_widget/show_alert_dialog.dart';

Future<void> showMessageDialog(
    BuildContext context, {
      @required String title,
      @required String message,
    }) =>
    showAlertDialog(
      context,
      title: title,
      content: message,
      defaultActionText: 'OK',
    );