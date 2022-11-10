import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var navKey = GlobalKey<NavigatorState>();
var navKey1 = GlobalKey<FormState>();
BuildContext get getContext => navKey.currentContext!;
Future<void> pushScreen(BuildContext context, Widget child) async {
  await Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
  //  CupertinoPageRoute(builder: (context) => child,
}

Future<void> pushReplacement(BuildContext context, Widget child) async {
  await Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void pop() {
  if (navKey.currentState!.canPop()) {
    navKey.currentState!.pop();
  }
}
