import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/screens/about_us.dart';
import 'package:Curve/screens/country.dart';
import 'package:Curve/screens/favourites.dart';
import 'package:Curve/screens/help.dart';
import 'package:Curve/screens/home.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/no_connection.dart';
import 'package:Curve/shared/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  @override
  NavigationPageState createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {

  APIServices service = new APIServices();
  late List districts;

  int selectedTabs = 0;
  final List<String> tabs = [
    "Home",
    'Watch List',
    'Dashboard',
    "Help",
    "About Us"
  ];

  @override
  initState() {
    service.getStatewiseAPIDataV2().then((data) {
      setState(() {
        districts = data;
      });
    });
    super.initState();
  }

  int _pageIndex = 0;

  _navigate(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Favourites();
      case 2:
        return Country();
      case 3:
        return AboutUs();
      case 4:
        return Help();
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
            backgroundColor: AppColors.PRIMARY_COLOR,
            appBar: AppBar(
              backgroundColor: AppColors.PRIMARY_COLOR,
              leading: IconButton(
                icon: Icon(Icons.menu),
                iconSize: 25.0,
                color: Colors.white,
                onPressed: () {},
              ),
              title: Text("Curve", style: TextStyle(color: AppColors.ACCENT_COLOR)),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 25.0,
                  color: Colors.white,
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: Search(districts),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  height: 70.0,
                  color: AppColors.PRIMARY_COLOR,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTabs = index;
                              // menu = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 25.0),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: index == selectedTabs
                                    ? Colors.white
                                    : Colors.white60,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0),
                          )
                        ],
                        color: AppColors.ACCENT_COLOR,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        )),
                    child: _navigate(selectedTabs),
                  ),
                )
              ],
            ),
          );
  }
}