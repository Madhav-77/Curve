import 'dart:convert';

import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/screens/district.dart';
import 'package:Curve/screens/states.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/spinner.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites extends StatefulWidget {
  @override
  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  List<String>? listFromSharedPref = [];
  APIServices service = new APIServices();
  Map mergedAPIData = new Map();
  List zoneData = [];
  Map stateWiseData = {};
  String active = "";
  late bool isListFound = false;

  @override
  void initState() {
    getSharedPreferenceData();
    getApiData();
    super.initState();
  }

  void getApiData() {
    service.getZonesData().then((data) {
      setState(() {
        zoneData = data['zones'];
      });
    });
    service.getStatewiseAPIData().then((dataCases) {
      setState(() {
        stateWiseData = dataCases;
      });
    });
  }

  void getSharedPreferenceData() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      listFromSharedPref = sharedPrefs.getStringList('watch_list_new');
      if (listFromSharedPref == null || listFromSharedPref?.length == 0 ) {
          isListFound = false;
      } else {
        isListFound = true;
      }
    });
  }

  getZoneDataFromList(String distCode) {
    Map district = {};
    for (int i = 0; i < zoneData.length; i++) {
      if (zoneData[i]['districtcode'] == distCode) {
        district = zoneData[i];
        break;
      }
    }
    return district;
  }

  void bindData() {
    int i = 0;
    if (stateWiseData.isNotEmpty) {
      setState(() {
        if (listFromSharedPref != null && stateWiseData != {}) {
          listFromSharedPref?.forEach((element) {
            var temp;
            Map tempMap = new Map();
            temp = json.decode(element);
            tempMap['zoneData'] = getZoneDataFromList(temp['distCode']);
            tempMap['dist'] = tempMap['zoneData']['district'];
            tempMap['stateCode'] = tempMap['zoneData']['statecode'];
            tempMap['zoneColor'] = tempMap['zoneData']['zone'];
            tempMap['confirmed'] = stateWiseData[temp['state']]['districtData']
                [temp['dist']]['confirmed'];
            tempMap['recovered'] = stateWiseData[temp['state']]['districtData']
                [temp['dist']]['recovered'];
            tempMap['state'] = temp['state'];
            mergedAPIData[i] = tempMap;
            i++;
          });
          i = 0;
        }
      });
    }
  }

  Widget showList() {
    return mergedAPIData != {}
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              child: ListView.builder(
                itemCount: mergedAPIData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              child: Text(
                                mergedAPIData[index]['stateCode'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.ACCENT_COLOR),
                              ),
                              radius: 22.0,
                              backgroundColor: AppColors.PRIMARY_COLOR,
                            ),
                            title: Text(
                              mergedAPIData[index][
                                  'dist']
                              ,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                              overflow: TextOverflow.fade,
                            ),
                            subtitle: Text(
                              "Confirmed: " +
                                  mergedAPIData[index]['confirmed'].toString() +
                                  " | Recovered: " +
                                  mergedAPIData[index]['recovered'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              List zoneDataToList = [];
                              zoneDataToList
                                  .add(mergedAPIData[index]['zoneData']);

                              _openDetailsPage(context, zoneDataToList);
                            },
                            trailing: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        : Spinner();
  }

  _openStateList(BuildContext context) =>
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => States()));

  Widget showLink() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        child: Center(
            child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _openStatesPage(context);
                },
                iconSize: 48.0,
              ),
              Text(
                "Click here to add districts to watchlist",
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
        )),
        height: MediaQuery.of(context).size.height/1.5,
      ),
    );
  }

  Future<void> _pageRefresh() async {
    setState(() {
      getSharedPreferenceData();
      getApiData();
    });
  }

  _openStatesPage(BuildContext context) =>
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => States()));

  @override
  Widget build(BuildContext context) {
    bindData();
    // TODO: implement build
    return RefreshIndicator(
      child: isListFound == true ? showList() :  showLink(),
      onRefresh: _pageRefresh,
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.ACCENT_COLOR,
    );
  }

  _openDetailsPage(BuildContext context, List test) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => District(test)));
}
