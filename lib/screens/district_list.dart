import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/screens/district.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DistrictList extends StatefulWidget {
  String state;
  String stateCode;
  DistrictList(this.state, this.stateCode);

  @override
  DistrictListState createState() => DistrictListState();
}

class DistrictListState extends State<DistrictList> {
  APIServices service = new APIServices();
  var apiData = {};
  var allData = [];
  Map districts = {};
  List dataList = [];
  List zoneData = [];
  var currentDistZone;
  ShowToast toast = new ShowToast();
  
  @override
  void initState() {
    service.getStatewiseAPIData().then((data) {
      setState(() {
        apiData = data;
      });
      districts = apiData[widget.state]['districtData'];
      districts.forEach((key, value) => dataList.add(key));
    });
    service.getZonesData().then((data) {
      setState(() {
        zoneData = data['zones'];
      });
    });
    super.initState();
  }

  getZoneData(String district, String stateCode){
    List currentDistZoneData = [];
    for (int i = 0; i < zoneData.length; i++) {
      if (zoneData[i]['district'] == district && zoneData[i]['statecode'] == stateCode) {
        currentDistZoneData.add(zoneData[i]);
        break;
      }
    }
    return currentDistZoneData;  
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
      backgroundColor: AppColors.ACCENT_COLOR,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(widget.state, style: TextStyle(color: AppColors.ACCENT_COLOR),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 22.0,
          color: AppColors.ACCENT_COLOR,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.album),
                    title: Text(
                      dataList[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    subtitle: Text(
                      "Active: " +
                          districts[dataList[index]]['active'].toString() +
                          " | Recovered: " +
                          districts[dataList[index]]['recovered'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // TODO: add snack bar 
                      getZoneData(dataList[index], widget.stateCode).isNotEmpty ? 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => District(getZoneData(dataList[index], widget.stateCode)), //, districts[dataList[index]]
                        ),
                      ) 
                      : toast.showCenterShortToast("District not found!");
                    }, 
                    trailing: Icon(Icons.arrow_forward_ios) 
                  ),
                ],
              ),
          );
        },
      ),
    );
  }
}
