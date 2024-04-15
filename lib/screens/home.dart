import 'package:Curve/resources/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 25.0, 0.0, 5.0),
              child: Container(
                child: Text(
                  "Covid-19",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                      child: Image(
                                    image: AssetImage(
                                        'assets/icons/iconfinder_allergy_air_disease_health_person_flu_people_sick_5859966 (1).png'),
                                    height: 70.0,
                                    width: 70.0,
                                  )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Text("Cold/Flu,\n Sore Throat",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.PRIMARY_COLOR))),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                      child: Image(
                                    image: AssetImage(
                                        'assets/icons/iconfinder_flu_illness_cold_fever_influenza_sick_infection_health_5859944.png'),
                                    height: 70.0,
                                    width: 70.0,
                                  )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Text("High Fever,\n Chills",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.PRIMARY_COLOR))),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                      child: Image(
                                    image: AssetImage(
                                        'assets/icons/iconfinder_cardiology_disease_medical_health_medicine_illness_heart_chest_5859968.png'),
                                    height: 70.0,
                                    width: 70.0,
                                  )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Text("Chest Pain/\nPressure",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.PRIMARY_COLOR))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                      child: Image(
                                    image: AssetImage(
                                        'assets/icons/iconfinder_27-Lung_5929217.png'),
                                    height: 70.0,
                                    width: 70.0,
                                  )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Text(
                                        "Difficulty Breathing,\nShortness of Breath",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.PRIMARY_COLOR))),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Center(
                                      child: Image(
                                    image: AssetImage(
                                        'assets/icons/iconfinder_pain_disease_health_neck_ache_neckache_hurt_5859958.png'),
                                    height: 70.0,
                                    width: 70.0,
                                  )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Text("Body Aches/Pains\nHeadache",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.PRIMARY_COLOR))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 25.0, 18.0, 5.0),
              child: Container(
                child: Text(
                  //011-23978046
                  "Are you feeling sick with any of the above symptoms? Don't hesitate to reach out for proper medical help.",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 5.0),
              child: Container(
                width: double.infinity,
                child: Expanded(
                  flex: 1,
                  child: new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: AppColors.COLOR_RED,
                      ),
                      onPressed: () => launch("tel://011-23978046"),
                      child: new Text(
                        "Covid-19 Helpline 24x7",
                        style: TextStyle(color: AppColors.ACCENT_COLOR),
                      )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 5.0, 18.0, 5.0),
              child: Card(
                  color: AppColors.PRIMARY_COLOR,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          child: Text(
                            "Prevention Tips",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ACCENT_COLOR),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                        child: Image(
                                      image: AssetImage(
                                          'assets/icons/iconfinder_24-Spreading_5929220.png'),
                                      height: 70.0,
                                      width: 70.0,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      child: Text("Social \nDistancing",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.ACCENT_COLOR))),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                        child: Image(
                                      image: AssetImage(
                                          'assets/icons/iconfinder_facial_mask_coronavirus_5964544.png'),
                                      height: 70.0,
                                      width: 70.0,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      child: Text("Always Cover \nyour nose",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.ACCENT_COLOR))),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    child: Center(
                                        child: Image(
                                      image: AssetImage(
                                          'assets/icons/iconfinder_wash_hands_regulary_5964550.png'),
                                      height: 70.0,
                                      width: 70.0,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      child: Text("Sanitize/\nWash hands",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.ACCENT_COLOR))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        indent: 18.0,
                        endIndent: 18.0,
                        color: AppColors.ACCENT_COLOR,
                      ),
                      Container(
                          child: TextButton(
                              // style: ButtonStyle(
                              //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              // ),
                              onPressed: null,
                              child: Text("View Guidelines",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: AppColors.ACCENT_COLOR)))),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}