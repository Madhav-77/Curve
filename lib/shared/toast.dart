import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  /* String textToShow;
  ShowToast(this.textToShow); */

  void showCenterShortToast(String textToShow) {
    Fluttertoast.showToast(
        msg: textToShow,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }
}