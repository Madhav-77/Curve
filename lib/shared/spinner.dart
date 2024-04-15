import 'package:Curve/resources/values/app_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: AppColors.ACCENT_COLOR,
      child: Center(
        child: SpinKitCircle(
          color: AppColors.PRIMARY_COLOR, 
          size: 50.0,
        ),
      ),
    );
  }
}