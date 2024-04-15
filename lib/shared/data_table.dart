import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/spinner.dart';
import 'package:flutter/material.dart';
// import 'package:data_tables/data_tables.dart';

class StatesDataTable extends StatefulWidget{

  String location;
  StatesDataTable(this.location);
  @override
  _StatesDataTableState createState() => _StatesDataTableState();
}

class _StatesDataTableState extends State<StatesDataTable>{

  var districtApiData = {};
  var apiData = {};
  APIServices service = new APIServices();
  int stateIndex = 0;
  late Map districts;
  List dataList = [];
  var data = [];
  var text = [];
  //String a;

  //new
  var districtApiDataV2 = [];
  int distIndex = 0;
  List distData = [];
  late bool sort;
  late int colIndex = 0;
  late String name;

  void fetchData() {
    service.getStatewiseAPIData().then((data) {
      if (data != null) {
        setState(() {
          districtApiData = data;
        });
      }
    });
    service.getData().then((data) {
      if (data != null) {
        setState(() {
          apiData = data;
        });
      }
    });

    //new
    service.getStatewiseAPIDataV2().then((data) {
      if (data != null) {
        setState(() {
          districtApiDataV2 = data;
          //print("3");
        });
        for (int i = 0; i < districtApiDataV2.length; i++) {
          if (districtApiDataV2[i]['state'] == widget.location) {
            distIndex = i;
            break;
          }
        }
        for (int i = 0;
            i < districtApiDataV2[distIndex]['districtData'].length;
            i++) {
          distData.add(districtApiDataV2[distIndex]['districtData'][i]);
        }
      }
      //print("2");
    });
    //modifyApiData();
  }

  @override
  void initState() {
    //new
    //print("1");
    sort = false;

    fetchData();
    super.initState();
  }

  Future<void> _getData() async {
    setState(() {
      fetchData();
    });
  }

  modifyApiData() {
    districts = districtApiData[widget.location]['districtData'];

    //adding key edistrictsx:(Gujarat:) to list dataList
    districts.forEach((key, value) => dataList.add(key));

    /* get user id any where with this */
    //final user = Provider.of<User>(context);
    text = [
      "Total Active",
      "Total Confirmed",
      "Total Recovered",
      "Total Deceased"
    ];

    //get the user's state data
    for (int i = 0; i < apiData['statewise'].length; i++) {
      if (apiData['statewise'][i]['state'] == widget.location) {
        stateIndex = i;
        break;
      }
    }

    data = [
      apiData['statewise'][stateIndex]['active'],
      apiData['statewise'][stateIndex]['confirmed'],
      apiData['statewise'][stateIndex]['deaths'],
      apiData['statewise'][stateIndex]['recovered'],
    ];
  }

  //new
  onSortColumn(int columnIndex, bool ascending, String nm) {
    if (columnIndex == colIndex) {
      if (ascending) {
        distData.sort((a, b) => a[nm].compareTo(b[nm]));
      } else {
        distData.sort((a, b) => b[nm].compareTo(a[nm]));
      }
    }
    print(distData.length);
  }

  dataTableBody() {
    return DataTable(
        columnSpacing: 0,
    sortAscending: sort,
    sortColumnIndex: colIndex,
    columns: [
      DataColumn(
          label: Text(
              'City',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          numeric: false,
          tooltip: "cities",
          onSort: (columnIndex, ascending) {
            setState(() {
              colIndex = columnIndex;
              sort = !sort;
              name = 'district';
            });
            onSortColumn(columnIndex, ascending, name);
          }),
      DataColumn(
          label: Text(
            'Active',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          numeric: true,
          tooltip: "active cases",
          onSort: (columnIndex, ascending) {
            setState(() {
              colIndex = columnIndex;
              sort = !sort;
              name = 'active';
            });
            onSortColumn(columnIndex, ascending, name);
          }),
      DataColumn(
          label: Text(
            'Confirmed',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black), 
            ),
          numeric: true,
          tooltip: "Confirmed cases",
          onSort: (columnIndex, ascending) {
            setState(() {
              colIndex = columnIndex;
              sort = !sort;
              name = 'confirmed';
            });
            onSortColumn(columnIndex, ascending, name);
          }),
      DataColumn(
          label: Text(
            'Deceased',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          numeric: true,
          tooltip: "Deceased cases",
          onSort: (columnIndex, ascending) {
            setState(() {
              colIndex = columnIndex;
              sort = !sort;
              name = 'deceased';
            });
            onSortColumn(columnIndex, ascending, name);
          }),
      DataColumn(
          label: Text(
            'Recovered',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          numeric: true,
          tooltip: "Recovered cases",
          onSort: (columnIndex, ascending) {
            setState(() {
              colIndex = columnIndex;
              sort = !sort;
              name = 'recovered';
            });
            onSortColumn(columnIndex, ascending, name);
          }),
    ],
    rows: distData
        .map((distr) => DataRow(
          cells: [
              DataCell(Text(distr['district'].toString(), style: TextStyle(fontSize: 14.0))),
              DataCell(Text(distr['active'].toString(), style: TextStyle(fontSize: 14.0))),
              DataCell(Text(distr['confirmed'].toString(), style: TextStyle(fontSize: 14.0))),
              DataCell(Text(distr['deceased'].toString(), style: TextStyle(fontSize: 14.0))),
              DataCell(Text(distr['recovered'].toString(), style: TextStyle(fontSize: 14.0))),
              /* DataCell(Text(distr['active'].toString())),
              DataCell(Text(distr['confirmed'].toString())),
              DataCell(Text(distr['deceased'].toString())),
              DataCell(Text(distr['recovered'].toString())), */
            ]))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (districtApiData.isNotEmpty &&
        apiData.isNotEmpty &&
        districtApiDataV2.isNotEmpty) {
    return Scaffold(
          appBar: AppBar(
            title: Text(widget.location, style: TextStyle(color: AppColors.ACCENT_COLOR)),
            backgroundColor: AppColors.PRIMARY_COLOR,
            leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 22.0,
            color: AppColors.ACCENT_COLOR,
            onPressed: () {
              Navigator.pop(context);
            })
          ),
          body: RefreshIndicator(
          child: OrientationBuilder(builder: (context, or) {
            double crossAxisCount = (or == Orientation.portrait) ? 3.0 : 5.0;
            return 
              Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(crossAxisCount),
                      /* child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, */
                        child: or == Orientation.portrait ? FittedBox(
                          child: dataTableBody(),
                        ) : Expanded(
                          child: dataTableBody(),
                        ),
                      /* ), */
                    ),
              );
          }),
          onRefresh: _getData,
        ),
    );
      } else {
      print('object');
      return Spinner();
    }
  }
}

  
/* 
  @override
  Widget build(BuildContext context) {
 */    //print(districtApiDataV2);
    //print("4");
    
      //print(distData);
      //print(distData[0]['district']);
      /* var allData = [];
      for(int i=1; i<apiData['statewise'].length; i++){
        var tempDataMap = {
          'active': apiData['statewise'][i]['active'],
          'lastupdatedtime': apiData['statewise'][i]['lastupdatedtime'],
          'recovered': apiData['statewise'][i]['recovered'],
          'state': apiData['statewise'][i]['state'],
          'statecode': apiData['statewise'][i]['statecode']
        };
        allData.add(tempDataMap);
      } */

   /*    // TODO: implement build
      return 
    } 
  } */