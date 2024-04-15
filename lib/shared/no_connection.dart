import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Opacity(
          opacity: 0.5,
          child: Container(
            child: Center(
              child: Text("Please check your internet connection!"),
            ),
          ),
        ),
    );
  }
}