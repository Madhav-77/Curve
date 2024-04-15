import 'dart:convert';
import 'package:Curve/resources/values/app_colors.dart';
import 'package:Curve/services/api_services.dart';
import 'package:Curve/shared/spinner.dart';
import 'package:Curve/shared/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class District extends StatefulWidget {
  List distZoneData;
  // Map distDataaa; , this.distDataaa
  District(this.distZoneData);

  @override
  DistrictState createState() => DistrictState();
}

class DistrictState extends State<District> {
  // late StreamSubscription<List<ConnectivityResult>> _connectionSubscription;
  // late String _connectionStatus;

  var currentDistZoneData = [];
  List locations = [];
  late bool isAddedToWatchList;
  Map districtCases = {};
  String lastUpdatedDate = "";
  // Map allDistrictCases = {};
  String urlCheckNotes = "";
  String urlCheckSource = "";
  String url = "";
  String zone = "";
  String dist = "";
  int deltaActive = 0;
  APIServices service = new APIServices();
  ShowToast toast = new ShowToast();

  @override
  void initState() {
    // print(widget.distZoneData);
    service.getStatewiseAPIData().then((dataCases) {
      setState(() {
        currentDistZoneData = widget.distZoneData;
        districtCases = dataCases[currentDistZoneData[0]['state']]
            ['districtData'][currentDistZoneData[0]['district']];
        // print(districtCases);
        isAddedToWatchList = false;
        zone = currentDistZoneData[0]['zone'];
        // dist = currentDistZoneData[0]['district'];
        watchListCheck(
            currentDistZoneData[0]['districtcode'],
            currentDistZoneData[0]['district'],
            currentDistZoneData[0]['state']);
      });
    });
    // service.getDistrictDailyData().then((data) {
    //   setState(() {
    //     int size = data['districtsDaily'][currentDistZoneData[0]['state']]
    //             [currentDistZoneData[0]['district']]
    //         .length;
    //     print(size);
    //     lastUpdatedDate = data['districtsDaily']
    //             [currentDistZoneData[0]['state']]
    //         [currentDistZoneData[0]['district']][size - 1]['date'];
    //   });
    // });
    // _connectionSubscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   setState(() {
    //     _connectionStatus = result.toString();
    //   });
    // });

    // setState(() {
    // });
    super.initState();
  }

  // @override
  // dispose() {
  //   _connectionSubscription.cancel();
  //   super.dispose();
  // }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  calculateActiveCases() {
    int active = 0;
    /* int size =// [distDailyAPIData
    'districtsDaily'][currentDistZoneData[0]['state']]
            [currentDistZoneData[0]['district']]
        .length;
    int activeCases = 0;
    for (int i = 0; i < size; i++) {
      active = int.parse(//d[istDailyAPIData
      'districtsDaily']
                  [currentDistZoneData[0]['state']]
              [currentDistZoneData[0]['district']][i]['active']
          .toString());
      if (i == 0) {
        activeCases = active;
      } else {
        activeCases += active;
      }
    } */
    active = districtCases['delta']['confirmed'] -
        (districtCases['delta']['recovered'] +
            districtCases['delta']['deceased']);
    if (active < 0) {
      active = 0;
    }
    return active;
  }

  watchListCheck(String distCode, String district, String state) async {
    List<String> listData = [];
    final sharedPrefs = await SharedPreferences.getInstance();
    Map mapData = {};
    mapData['distCode'] = distCode;
    mapData['dist'] = district;
    mapData['state'] = state;
    var encode = json.encode(mapData);
    // print(encode);
    listData = [];
    // print(encode);
    if (listData != []) {
      listData.forEach((element) {
        if (element == encode) {
          setState(() {
            isAddedToWatchList = true;
          });
        }
      });
    }
  }

  void addToWatchList(String distCode, String district, String state) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    Map mapDataEncode = {};
    mapDataEncode['distCode'] = distCode;
    mapDataEncode['dist'] = district;
    mapDataEncode['state'] = state;
    var encodedMap = json.encode(mapDataEncode);
    // sharedPrefs.remove('watch_list_new');
    // List<String> listData = List<String>();
    // listData = sharedPrefs.getStringList('watch_list_new');
    List<String> listForSharedPref = [];
    if (sharedPrefs.getStringList('watch_list_new') != null) {
      listForSharedPref = sharedPrefs.getStringList('watch_list_new')!;
      listForSharedPref.add(encodedMap);
      if (sharedPrefs.setStringList('watch_list_new', listForSharedPref) !=
          []) {
        toast
            .showCenterShortToast("District successfully added to watch list!");
      } else {
        toast.showCenterShortToast("Sorry! District failed to add.");
      }
    } else {
      listForSharedPref.add(encodedMap);
      // sharedPrefs.setStringList('watch_list_new', listForSharedPref);
      if (sharedPrefs.setStringList('watch_list_new', listForSharedPref) !=
          null) {
        toast
            .showCenterShortToast("District successfully added to watch list!");
      } else {
        toast.showCenterShortToast("Sorry! District failed to add.");
      }
    }
    // print(isAddedToWatchList);
    // encodedData = json.encode(data);
    // encodedData = json.encode(encodedData);
    /* if(!isAddedToWatchList){
      locations.add(loc);
      sharedPrefs.setStringList('watch_list_new', locations);
    } */
  }

  void removeAddedItem(String distCode, String district, String state) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    Map mapDataEncode = {};
    mapDataEncode['distCode'] = distCode;
    mapDataEncode['dist'] = district;
    mapDataEncode['state'] = state;
    var encodedMap = json.encode(mapDataEncode);
    List<String> listForSharedPref = [];

    if (sharedPrefs.getStringList('watch_list_new') != null) {
      listForSharedPref = sharedPrefs.getStringList('watch_list_new')!;
      for (String element in listForSharedPref) {
        if (element == encodedMap) {
          listForSharedPref.remove(element);
          break;
        }
      }
      // sharedPrefs.setStringList('watch_list_new', listForSharedPref);
      if (sharedPrefs.setStringList('watch_list_new', listForSharedPref) !=
          null) {
        toast.showCenterShortToast("District has been successfully removed!");
      } else {
        toast.showCenterShortToast("Sorry! District failed to remove.");
      }
    }
    // watchListCheck(data);
  }

  Widget topCustomBox() {
    /* var newFormat = DateFormat("yyyy-MM-dd");
    String st = currentDistZoneData[0]['lastupdated'];
    st.replaceAll("-", "/");
    print(currentDistZoneData[0]['lastupdated'].replaceAll("-", "/"));
    var date = DateTime.parse(st);
    var formatDAte = newFormat.format(date); */
    Color color = zone == "Green"
        ? Color(0xff4caf50)
        : zone == "Red"
            ? Color(0xfff44336)
            : zone == "Orange" ? Color(0xffffc107) : Color(0xff443a49);
            
    return Stack(
      children: <Widget>[
        PhysicalShape(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3.0,
          shadowColor: Colors.black,
          color: color,
          clipper: WaveClipperOne(flip: true),
          // clipBehavior: Clip.,//WaveClipperOne(flip: true)
          child: Container(
            height: 240,
          ),
        ),
        PhysicalShape(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3.0,
          // shadowColor: Colors.black,
          color: AppColors.PRIMARY_COLOR,
          clipper: WaveClipperOne(flip: true),
          // clipBehavior: Clip.,//WaveClipperOne(flip: true)
          child: Container(
            height: 230,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 22.0,
                                  color: AppColors.ACCENT_COLOR,
                                )),
                          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAddedToWatchList = !isAddedToWatchList;
                                });
                                isAddedToWatchList
                                    ? addToWatchList(
                                        currentDistZoneData[0]['districtcode'],
                                        currentDistZoneData[0]['district'],
                                        currentDistZoneData[0]['state'])
                                    : removeAddedItem(
                                        currentDistZoneData[0]['districtcode'],
                                        currentDistZoneData[0]['district'],
                                        currentDistZoneData[0]['state']);
                              },
                              child: isAddedToWatchList == false
                                  ? Icon(
                                      Icons.bookmark_border,
                                      size: 30.0,
                                      color: AppColors.ACCENT_COLOR,
                                    )
                                  : Icon(
                                      Icons.bookmark,
                                      size: 30.0,
                                      color: AppColors.ACCENT_COLOR,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              text: TextSpan(
                                text: currentDistZoneData[0]['district'].length < 20
                                    ? currentDistZoneData[0]['district'] +
                                        ", " +
                                        currentDistZoneData[0]['statecode'] +
                                        "\n"
                                    : currentDistZoneData[0]['district'] +
                                        ",\n" +
                                        currentDistZoneData[0]['statecode']+" ",
                                style: TextStyle(
                                    color: AppColors.ACCENT_COLOR,
                                    fontSize:
                                        currentDistZoneData[0]['district'].length >
                                                20
                                            ? 25.0
                                            : 30.0,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: "Updated on: " + lastUpdatedDate,
                                      style: TextStyle(
                                        color: AppColors.ACCENT_COLOR,
                                        fontSize: 12.0,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget mainGraph() {
  //   return Container(
  //       child: DistrictLineChart(currentDistZoneData[0]['state'],
  //           currentDistZoneData[0]['district']) //, distDailyAPIData
  //       );
  // }

  Widget casesCard() {
    deltaActive = calculateActiveCases();
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 30.0),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Active\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.ACTIVE_COLOR),
                      children: [
                        TextSpan(
                          text:
                              "\n" + districtCases['active'].toString() + "\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.ACTIVE_COLOR),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.arrow_upward,
                              size: 15.0, color: AppColors.ACTIVE_COLOR),
                        ), //
                        TextSpan(
                          text: deltaActive.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.ACTIVE_COLOR),
                        ),
                      ]),
                ],
              )),
        ),
        Container(
            height: 40.0,
            child: VerticalDivider(color: AppColors.DECEASED_COLOR)),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 30.0),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Confirmed\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.CONFIRMED_COLOR),
                      children: [
                        TextSpan(
                          text: "\n" +
                              districtCases['confirmed'].toString() +
                              "\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.CONFIRMED_COLOR),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.arrow_upward,
                              size: 15.0, color: AppColors.CONFIRMED_COLOR),
                        ), //
                        TextSpan(
                          text: districtCases['delta']['confirmed'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.CONFIRMED_COLOR),
                        ),
                      ]),
                ],
              )),
        ),
        Container(
            height: 40.0,
            child: VerticalDivider(color: AppColors.DECEASED_COLOR)),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 30.0),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Recovered\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.RECOVERED_COLOR),
                      children: [
                        TextSpan(
                          text: "\n" +
                              districtCases['recovered'].toString() +
                              "\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.RECOVERED_COLOR),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.arrow_upward,
                              size: 15.0, color: AppColors.RECOVERED_COLOR),
                        ), //
                        TextSpan(
                          text: districtCases['delta']['recovered'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.RECOVERED_COLOR),
                        ),
                      ]),
                ],
              )),
        ),
        Container(
            height: 40.0,
            child: VerticalDivider(color: AppColors.DECEASED_COLOR)),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 30.0),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Deceased\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.DECEASED_COLOR),
                      children: [
                        TextSpan(
                          text: "\n" +
                              districtCases['deceased'].toString() +
                              "\n",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.DECEASED_COLOR),
                        ),
                        WidgetSpan(
                          child: Icon(Icons.arrow_upward,
                              size: 15.0, color: AppColors.DECEASED_COLOR),
                        ), //
                        TextSpan(
                          text: districtCases['delta']['deceased'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.DECEASED_COLOR),
                        ),
                      ]),
                ],
              )),
        ),
      ],
    ));
  }

  Widget customText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: Container(
        child: Text(
          "Daily Statistics",
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR),
        ),
      ),
    );
  }

  Widget others() {
    return Row(
      children: <Widget>[
        Container(
          child: districtCases['notes'] != ""
              ? RichText(
                  text: TextSpan(
                      text: 'Notes: ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: districtCases['notes'],
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                urlCheckNotes = districtCases['notes'];
                                urlCheckNotes.substring(0, 4) == "http"
                                    ? _launchURL(districtCases['notes'])
                                    : print(urlCheckNotes);
                                // navigate to desired screen
                              })
                      ]),
                )
              : Text(""),
        ),
        Container(child: Text("Zone: " + currentDistZoneData[0]['zone'])),
        Container(
          child: currentDistZoneData[0]['source'] != ""
              ? RichText(
                  text: TextSpan(
                      text: 'Source: ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                            text: currentDistZoneData[0]['source'],
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                urlCheckSource =
                                    currentDistZoneData[0]['source'];
                                urlCheckSource.substring(0, 4) == "http"
                                    ? _launchURL(
                                        currentDistZoneData[0]['source'])
                                    : print(urlCheckSource);
                                // navigate to desired screen
                              })
                      ]),
                )
              : Text(""),
        ),
        Container(child: Text("Starting Date: ")),
        Container(child: Text("State: "))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(activeCases);

    // print("active: $active");

    return currentDistZoneData.isNotEmpty
            ? Scaffold(
                backgroundColor: AppColors.ACCENT_COLOR,
                body: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          topCustomBox(),
                          customText(),
                          casesCard(),
                          // mainGraph(),
                        ],
                      ),
                    ),
                  );
                }),
              )
            : Spinner();
  }
}

class ZoneData {
  String district;
  String districtCode;
  String lastUpdatedOn;
  String source;
  String state;
  String stateCode;
  String zone;

  ZoneData(this.district, this.districtCode, this.lastUpdatedOn, this.source,
      this.state, this.stateCode, this.zone);
}

/* ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return RadialGradient(
                              center: Alignment.center,
                              radius: 0.5,
                              colors: <Color>[
                                Colors.orangeAccent,
                                Colors.deepOrange.shade900
                              ],
                              tileMode: TileMode.clamp,
                            ).createShader(bounds);
                          },
                          child: 
), */

/*Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 50.0, 20.0, 50.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: RichText(
                                          text:
                                               stringLength > 12
                                            ? TextSpan(
                                                text: one + "\n",
                                                style: TextStyle(
                                                    color: AppColors.ACCENT_COLOR,
                                                    fontSize: 30.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                                    TextSpan(
                                                      text: two + "\n",
                                                      style: TextStyle(
                                                          color: AppColors.ACCENT_COLOR,
                                                          fontSize: 30.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: [
                                                        TextSpan(
                                                            text: "Updated on: " +
                                                                currentDistZoneData[
                                                                        0][
                                                                    'lastupdated'],
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.ACCENT_COLOR,
                                                              fontSize: 12.0,
                                                            )),
                                                      ],
                                                    )
                                                  ])
                                            :  */
/*                 TextSpan(
                                            text: currentDistZoneData[0]
                                                            ['district']
                                                        .length <
                                                    22
                                                ? currentDistZoneData[0]
                                                        ['district'] +
                                                    ", " +
                                                    currentDistZoneData[0]
                                                        ['statecode'] +
                                                    "\n"
                                                : currentDistZoneData[0]
                                                        ['district'] +
                                                    ",\n" +
                                                    currentDistZoneData[0]
                                                        ['statecode'] +
                                                    "\n",
                                            style: TextStyle(
                                                color: AppColors.ACCENT_COLOR,
                                                fontSize: currentDistZoneData[0]
                                                                ['district']
                                                            .length >
                                                        15
                                                    ? 25.0
                                                    : 30.0,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                  text: "Updated on: " +
                                                      currentDistZoneData[0]
                                                          ['lastupdated'],
                                                  style: TextStyle(
                                                    color: AppColors.ACCENT_COLOR,
                                                    fontSize: 12.0,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAddedToWatchList =
                                                  !isAddedToWatchList;
                                            });
                                            isAddedToWatchList
                                                ? addToWatchList(
                                                    currentDistZoneData[0]
                                                        ['districtcode'],
                                                    currentDistZoneData[0]
                                                        ['district'],
                                                    currentDistZoneData[0]
                                                        ['state'])
                                                : removeAddedItem(
                                                    currentDistZoneData[0]
                                                        ['districtcode'],
                                                    currentDistZoneData[0]
                                                        ['district'],
                                                    currentDistZoneData[0]
                                                        ['state']);
                                          },
                                          child: isAddedToWatchList == false
                                              ? Icon(
                                                  Icons.bookmark_border,
                                                  size: 30.0,
                                                  color: AppColors.ACCENT_COLOR,
                                                )
                                              : Icon(
                                                  Icons.bookmark,
                                                  size: 30.0,
                                                  color: AppColors.ACCENT_COLOR,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ), */

/* 
Scaffold(
      /* appBar: AppBar(
        actionsIconTheme: Icon(Icons.bookmark_border),
      ), */
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            titleSpacing: 0.0,
            //shape: CustomShapeBorder(),
            backgroundColor: color,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            stretch: true,
            /* onStretchTrigger: () {
              padding = 20.0;// Function callback for stretch
            }, */
            flexibleSpace: FlexibleSpaceBar( 
              //titlePadding: EdgeInsets.only(left: 30.0),           
              centerTitle: false,
              title: Text(currentDistZoneData[0]['district']+", "+currentDistZoneData[0]['state'],
                  style: TextStyle(
                    color: AppColors.ACCENT_COLOR,
                    fontSize: 16.0,
                  )),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              child: Center(child: RaisedButton(onPressed: () { print("anc"); },)),
            ),
          ),
        ],
      ),
    ); */

/* ClipPath(
        clipper: WaveClipperOne(flip: true),
        child: Container(
          height: 200,
          color: newColor,
          child: Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          widget.location,
                          style: TextStyle(
                              color: AppColors.ACCENT_COLOR,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "Updated on: "+currentDistZoneData[0]['lastupdated'],
                          style: TextStyle(
                              color: AppColors.ACCENT_COLOR,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ), */

/* 
class WaveClipper extends CustomClipper<Path> {
 @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height / 4.25);
    var firstControlPoint = new Offset(size.width / 4, size.height / 3);
    var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 60);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height / 4 - 65);
    var secondEndPoint = new Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) 
  {
    return null;
  }
} */

/* DecoratedBox(
                                          position:
                                              DecorationPosition.foreground,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              center:
                                                  const Alignment(-0.5, -0.6),
                                              radius: 0.15,
                                              colors: <Color>[
                                                const Color(0xFFEEEEEE),
                                                const Color(0xFF111133),
                                              ],
                                              stops: <double>[0.9, 1.0],
                                            ),
                                          ),
                                          child:  */
