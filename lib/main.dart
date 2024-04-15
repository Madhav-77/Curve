import 'package:Curve/screens/country.dart';
import 'package:Curve/screens/home.dart';
import 'package:Curve/screens/states.dart';
import 'package:Curve/shared/data_table.dart';
import 'package:Curve/shared/navigator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => Home());
          case "/country":
            return MaterialPageRoute(builder: (context) => Country());
          case "/states":
            return MaterialPageRoute(builder: (context) => States());
          case "/table":
            String state = settings.arguments as String;
            return MaterialPageRoute(builder: (context) => StatesDataTable(state));
          default:
            return MaterialPageRoute(builder: (context) => Home());
        }
      },
      home: NavigationPage(),
    );
  }
}
