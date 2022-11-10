import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void showToast(String title, Color color) {
  var cancel = BotToast.showSimpleNotification(
      title: title,
      backgroundColor: color,
      titleStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
}

//Gọi loadingGIF() để đóng loading.
void showLoading(int seconds) {
  var loadingGIF = BotToast.showCustomLoading(
    duration: Duration(seconds: seconds),
    toastBuilder: (cancelFunc) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/loading3gif.gif',
            width: 100,
            height: 100,
          ),
        ),
      );
    },
  );
}
