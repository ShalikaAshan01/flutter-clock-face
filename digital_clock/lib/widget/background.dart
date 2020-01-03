import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Color colorPrimary;
  final Color colorSecondary;
  final bool lightMode;
  final String path;
  final Widget child;

  const Background(
      {Key key,
      this.path,
      this.child,
      this.colorPrimary,
      this.colorSecondary,
      this.lightMode})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!lightMode)
      return AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: 1000),
        child: child,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28313B), Color(0xFF485461)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("third_party/img/dark.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      );
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(path),
            fit: BoxFit.fill,
          ),
          gradient: LinearGradient(
            colors: [colorPrimary, colorSecondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: child,
    );
  }
}
