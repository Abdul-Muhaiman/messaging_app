import 'package:flutter/material.dart';

class UIHelper {
  static showLoadingDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 30),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(
              height: 30,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  static showAlertDialog(BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        title: Center(child: Text(title)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}
