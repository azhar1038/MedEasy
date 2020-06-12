import 'package:flutter/material.dart';
import 'package:medeasy/src/widget/loader.dart';

class WaitDialog {
  final BuildContext context;
  WaitDialog(this.context);

  showWaitDialog(bool dismissable) {
    showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => dismissable,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      },
    );
  }

  removeWaitDialog() {
    Navigator.of(context).pop();
  }
}
