import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/screens/district.dart';
import 'package:Curve/screens/district_list.dart';
import 'package:Curve/services/api_services.dart';
import 'package:flappy_search_bar_ns/flappy_search_bar_ns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class States extends StatefulWidget {
  final String? title;
  const States({Key? key, this.title}) : super(key: key);
  @override
  StatesState createState() => StatesState();
}

class StatesState extends State<States> {
  APIServices service = new APIServices();
  var apiData = {};
  var allData = [];

  @override
  void initState() {
    service.getData().then((data) {
      setState(() {
        apiData = data;
      });
      getList(apiData);
    });
    super.initState();
  }

  getList(var data) {
    for (int i = 1; i < data['statewise'].length; i++) {
      var tempDataMap = {
        'active': data['statewise'][i]['active'],
        'confirmed': data['statewise'][i]['confirmed'],
        'lastupdatedtime': data['statewise'][i]['lastupdatedtime'],
        'recovered': data['statewise'][i]['recovered'],
        'state': data['statewise'][i]['state'],
        'statecode': data['statewise'][i]['statecode']
      };
      allData.add(tempDataMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: AppColors.ACCENT_COLOR,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text("Curve", style: TextStyle(color: AppColors.ACCENT_COLOR),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 22.0,
          color: AppColors.ACCENT_COLOR,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: allData.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                leading: Icon(Icons.album),
                title: Text(
                  allData[index]['state'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                subtitle: Text(
                  "Active: " +
                      allData[index]['active'] +
                      " | Recovered: " +
                      allData[index]['recovered'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DistrictList(allData[index]['state'], allData[index]['statecode']),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
