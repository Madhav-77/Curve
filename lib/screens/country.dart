import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/shared/line_chart.dart';
import 'package:Curve/screens/district_list.dart';
import 'package:Curve/screens/states.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/data_table.dart';
import 'package:Curve/shared/spinner.dart';
import 'package:flutter/material.dart';

class Country extends StatefulWidget {
  final String? title;

  const Country({Key? key, this.title}) : super(key: key);
  @override
  CountryState createState() => CountryState();
}

class CountryState extends State<Country> {
  APIServices service = new APIServices();
  var stateWiseAPIData = [];
  Map<String, dynamic> statesDailyAPIData = new Map();

  String stateCode = '';
  String active = '';
  String confirmed = '';
  String recovered = '';
  String deceased = '';
  late int deltaActive;
  late int deltaConfirmed = 0;
  late int deltaRecovered;
  late int deltaDeceased;

  Map highestCount = new Map();

  late String lastupdatedtime;
  late String state;
  var dateSplit;
  int selected = 0;

  @override
  void initState() {
    service.getData().then((data) {
      setState(() {
        // initial load set data to index 0, which is "TT"/India
        print("data['statewise']");
        print(data['statewise']);
        stateWiseAPIData = data['statewise'];
        stateCode = stateWiseAPIData[0]['statecode'];

        active = stateWiseAPIData[0]['active'];
        confirmed = stateWiseAPIData[0]['confirmed'];
        recovered = stateWiseAPIData[0]['recovered'];
        deceased = stateWiseAPIData[0]['deaths'];

        deltaConfirmed = int.parse(stateWiseAPIData[0]['deltaconfirmed']);
        deltaRecovered = int.parse(stateWiseAPIData[0]['deltarecovered']);
        deltaDeceased = int.parse(stateWiseAPIData[0]['deltadeaths']);
        deltaActive = deltaConfirmed - (deltaRecovered + deltaDeceased);

        lastupdatedtime = stateWiseAPIData[0]['lastupdatedtime'];
        dateSplit = lastupdatedtime.split(' ');
        lastupdatedtime = dateSplit[0];
        state = 'India';
      });
    });

    service.getStatesDailyData().then((data) {
      setState(() {
        statesDailyAPIData = data;
      });
    });
    super.initState();
  }

  Widget listStates() {
    print("in list states stateWiseAPIData");
    return Container(
            height: 140.0,
            child: ListView.builder(
                itemExtent: 100,
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                scrollDirection: Axis.horizontal,
                itemCount: stateWiseAPIData.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        stateCode = stateWiseAPIData[index]['statecode'];

                        active = stateWiseAPIData[index]['active'];
                        confirmed = stateWiseAPIData[index]['confirmed'];
                        recovered = stateWiseAPIData[index]['recovered'];
                        deceased = stateWiseAPIData[index]['deaths'];

                        deltaConfirmed = int.parse(
                            stateWiseAPIData[index]['deltaconfirmed']);
                        deltaRecovered = int.parse(
                            stateWiseAPIData[index]['deltarecovered']);
                        deltaDeceased =
                            int.parse(stateWiseAPIData[index]['deltadeaths']);
                        deltaActive =
                            deltaConfirmed - (deltaRecovered + deltaDeceased);

                        state = index != 0
                            ? stateWiseAPIData[index]['state']
                            : 'India';
                        lastupdatedtime = index != 0
                            ? stateWiseAPIData[index]['lastupdatedtime']
                            : stateWiseAPIData[0]['lastupdatedtime'];
                        dateSplit = lastupdatedtime.split(' ');
                        lastupdatedtime = dateSplit[0];
                        selected = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            child: Text(
                              stateWiseAPIData[index]['statecode'] == "TT"
                                  ? "IND"
                                  : stateWiseAPIData[index]['statecode'],
                              style: TextStyle(
                                  color: AppColors.ACCENT_COLOR,
                                  fontSize: index == selected ? 20.0 : 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            radius: index == selected ? 35.0 : 20.0,
                            backgroundColor: AppColors.PRIMARY_COLOR,
                          ),
                          SizedBox(height: 6.0),
                          Text(
                            stateWiseAPIData[index]['state'] == "Total"
                                ? "India"
                                : stateWiseAPIData[index]['state'],
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Widget charts() {
    return statesDailyAPIData.isNotEmpty
        ? Container(
            child: Container(
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                //padding: const EdgeInsets.all(20),
                //crossAxisSpacing: 10,
                //mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    child: 
                    // stateCode != ''
                    //     ? ActiveLineChart(stateCode.toLowerCase(), active,
                    //         deltaActive.toString(), statesDailyAPIData)
                    //     : 
                        LineChart("active"),
                    //color: Colors.teal[200],
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: 
                    // stateCode != ''
                    //     ? ConfirmedLineChart(stateCode.toLowerCase(), confirmed,
                    //         deltaConfirmed.toString(), statesDailyAPIData)
                    //     : 
                        LineChart("confirmed"),
                    //color: Colors.teal[100],
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: 
                    // stateCode != ''
                    //     ? RecoveredLineChart(stateCode.toLowerCase(), recovered,
                    //         deltaRecovered.toString(), statesDailyAPIData)
                    //     : 
                        LineChart("recovered"),
                    //color: Colors.teal[200],
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: 
                    // stateCode != ''
                    //     ? DeceasedLineChart(stateCode.toLowerCase(), deceased,
                    //         deltaDeceased.toString(), statesDailyAPIData)
                    //     : 
                        LineChart("deceased"),
                    // color: Colors.teal[200],
                  ),
                ],
              ),
            ),
          )
        : Spinner();
  }

  Widget titleState() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          state,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget subtitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 20.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Last update: " + lastupdatedtime,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  Widget button() {
    double elevation = 5.0;
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 100.0)),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10.0),
              shape: StadiumBorder(),
              animationDuration: Duration(milliseconds: 100),
              elevation: elevation,
              backgroundColor: AppColors.PRIMARY_COLOR,
              textStyle: TextStyle(color: AppColors.ACCENT_COLOR)
            ),
            child: const Text(
              'Table Format',
              style: TextStyle(fontSize: 18, color: AppColors.ACCENT_COLOR),
            ),
            // textColor: AppColors.ACCENT_COLOR,
            // color: AppColors.PRIMARY_COLOR,
            // splashColor: Colors.blueAccent,
            // colorBrightness: Brightness.dark,
            // highlightElevation: 2,
            // child: Text('Table Format'),
            // onHighlightChanged: (valueChanged) {
            //   if (valueChanged) {
            //     elevation = 2.0;
            //   } else {
            //     elevation = 5.0;
            //   }
            // },
            //elevation: elevation,
            onPressed: () {
              // print(state);
              state != 'India' ? _openDataTable(context, state) : print('a');
            },
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0)),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10.0),
            backgroundColor: AppColors.PRIMARY_COLOR,
            shape: StadiumBorder(),
            animationDuration: Duration(milliseconds: 100),
            elevation: elevation,
            textStyle: TextStyle(color: AppColors.ACCENT_COLOR)
            ),
            child: const Text(
              'View Districts',
              style: TextStyle(fontSize: 18, color: AppColors.ACCENT_COLOR),
            ),
            // splashColor: Colors.blueAccent,
            // colorBrightness: Brightness.dark,
            // highlightElevation: 2,
            // onHighlightChanged: (valueChanged) {
            //   if (valueChanged) {
            //     elevation = 2.0;
            //   } else {
            //     elevation = 5.0;
            //   }
            // },
            //elevation: elevation,
            onPressed: () {
              state == 'India'
                  ? _openStatesPage(
                      context) /* Navigator.pushNamed(context, '/state') */
                  : _openDistrictList(context, state, stateCode);
            },
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0)),
      ],
    );
  }

  _openStatesPage(BuildContext context) =>
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => States()));

  _openDistrictList(BuildContext context, String state, String statecode) =>
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => DistrictList(state, statecode)));

  _openDataTable(BuildContext context, String state) =>
      Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => StatesDataTable(state)));

  Widget tabs() {
    // print(highestCount['active']['case']);
    return highestCount.isNotEmpty
        ? Container(
            height: 125.0,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
            child: Expanded(
                child: Card(
                    color: AppColors.PRIMARY_COLOR,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Highest number of cases",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "Active",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['active']['case']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['active']['date']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  height: 40.0,
                                  child: VerticalDivider(
                                      color: AppColors.DECEASED_COLOR)),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "Confirmed",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['confirmed']['case']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['confirmed']['date']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  height: 40.0,
                                  child: VerticalDivider(
                                      color: AppColors.DECEASED_COLOR)),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "Recovered",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['recovered']['case']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['recovered']['date']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  height: 40.0,
                                  child: VerticalDivider(
                                      color: AppColors.DECEASED_COLOR)),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "Deceased",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['deceased']['case']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        highestCount['deceased']['date']
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))))
        : Spinner();
  }

/*  */

  void _calculateHighestCount() {
    // print(stateWiseAPIData);
    if (stateWiseAPIData.isNotEmpty && statesDailyAPIData.isNotEmpty) {
      int size = statesDailyAPIData['states_daily'].length;
      String active = "";
      String confirmed = "";
      String recovered = "";
      String deceased = "";
      String date = "";
      // Map highestKeyValues = new Map();
      highestCount['active'] = {"case": 0, "date": ""};
      highestCount['confirmed'] = {"case": 0, "date": ""};
      highestCount['recovered'] = {"case": 0, "date": ""};
      highestCount['deceased'] = {"case": 0, "date": ""};

      if (statesDailyAPIData.isNotEmpty) {
        for (int i = 0; i < size; i++) {
          if ((statesDailyAPIData['states_daily'][i]['status'] ==
              "Confirmed")) {
            confirmed =
                statesDailyAPIData['states_daily'][i][stateCode.toLowerCase()];
            if (highestCount['confirmed']['case'] < int.parse(confirmed)) {
              date = statesDailyAPIData['states_daily'][i]["date"];
              highestCount['confirmed']['case'] = int.parse(confirmed);
              highestCount['confirmed']['date'] = date;
            }
            i++;
            if ((statesDailyAPIData['states_daily'][i]['status'] ==
                "Recovered")) {
              recovered = statesDailyAPIData['states_daily'][i]
                  [stateCode.toLowerCase()];
              if (highestCount['recovered']['case'] < int.parse(recovered)) {
                date = statesDailyAPIData['states_daily'][i]["date"];
                highestCount['recovered']['case'] = int.parse(recovered);
                highestCount['recovered']['date'] = date;
              }
              i++;
              if ((statesDailyAPIData['states_daily'][i]['status'] ==
                  "Deceased")) {
                deceased = statesDailyAPIData['states_daily'][i]
                    [stateCode.toLowerCase()];
                if (highestCount['deceased']['case'] < int.parse(deceased)) {
                  date = statesDailyAPIData['states_daily'][i]["date"];
                  highestCount['deceased']['case'] = int.parse(deceased);
                  highestCount['deceased']['date'] = date;
                }
                active = (int.parse(confirmed) -
                        (int.parse(recovered) + int.parse(deceased)))
                    .toString();
                if (highestCount['active']['case'] < int.parse(active)) {
                  date = statesDailyAPIData['states_daily'][i]["date"];
                  highestCount['active']['case'] = int.parse(active);
                  highestCount['active']['date'] = date;
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("deltaConfirmed  = $deltaConfirmed");
    _calculateHighestCount();
    return stateWiseAPIData.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                listStates(), 
                titleState(),
                subtitle(),
                charts(),
                tabs(),
                button(),
              ],
            ),
          )
        : Spinner();
  }
}
