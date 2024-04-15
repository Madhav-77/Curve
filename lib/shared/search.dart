import 'package:Curve/screens/district.dart';
import 'package:Curve/screens/district_list.dart';
import 'package:Curve/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* service.getZonesData().then((data) {
      setState(() {
        zoneData = data['zones'];
      });
    });
 */
class Search extends SearchDelegate<String> {
  List cities;
  Search(this.cities);
  List city = [];
  List states = [];
  APIServices service = new APIServices();
  List zonesData = [];
  List<String>? recentsSearch = [];
  List statecode = [];

  void setApiData() {
    service.getZonesData().then((data) {
      zonesData = data['zones'];
    });
  }

  void setSearchList() {
    // print(this.cities[1]['districtData'][0]['district']);
    if (this.cities != []) {
      this.cities.forEach((state) {
        List temp = [];
        String stateTemp = "";
        temp = state['districtData'];
        // c.add(temp[0]['district']);
        // print(c);
        stateTemp = state['state'];
        city.add(stateTemp);
        states.add(stateTemp);
        statecode.add(state['statecode']);
        temp.forEach((dist) {
          city.add(dist['district']);
        });
      });
    }
  }

  getZoneData(String district) {
    List currentDistZoneData = [];
    for (int i = 0; i < zonesData.length; i++) {
      if (zonesData[i]['district'] == district) {
        currentDistZoneData.add(zonesData[i]);
      }
    }
    return currentDistZoneData;
  }

  void showCenterShortToast() {
    Fluttertoast.showToast(
        msg: "District not found!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  addToRecent(var district) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    // sharedPrefs.remove('recent_search_list');
    var recent = sharedPrefs.getStringList('recent_search_list');
    List<String>? recents = [];
    bool isInList = false;
    int indexOfRepeatElement = 0;
    String temp;

    if (recent != null) {
      int length = recent.length;
      for (int i = 0; i < length; i++) {
        if (recent[i] == district) {
          isInList = true;
          indexOfRepeatElement = i;
          break;
        }
      }
      if (isInList) {
        recents = recent;
        // recents[indexOfRepeatElement] = rece
        temp = recents[indexOfRepeatElement];
        for (int i = indexOfRepeatElement; i > 0; i--) {
          recents[i] = recents[i - 1];
        }
        recents[0] = temp;
      } else {
        if (length < 5) {
          recents = recent;
          /* recents.insert(0, district);
          sharedPrefs.setStringList('recent_search_list', recents);    
          print(recents); */
        } else if (length >= 5) {
          recent.removeLast();
          recents = recent;
        }
        recents.insert(0, district);
        /* sharedPrefs.setStringList('recent_search_list', recents);    
        print(recents); */
      }
    } else {
      recents.add(district);
    }
    sharedPrefs.setStringList('recent_search_list', recents);
    // recent = recent.reversed.toList();
  }

  void getRecentSearch() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    recentsSearch = sharedPrefs.getStringList('recent_search_list');
  }

  // final cities = ["One", "Two", "Three", "Four", "Five"];

  // final rCities = ["One", "Two"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String firstLetter = "";
    String restString = "";
    String finalQuery = "";
    if (query.isNotEmpty) {
      firstLetter = query[0].toUpperCase();
      restString = query.substring(1);
      finalQuery = firstLetter + restString; // temp2 = query.substring(1);
    }
    if (city.isEmpty) {
      setSearchList();
    }
    getRecentSearch();
    final suggestionsList = query.isEmpty && recentsSearch == []
        ? []
        : query.isEmpty
            ? recentsSearch
            : city
                .where((element) => element.startsWith(finalQuery))
                .toList(); //query.isEmpty ? rCities : cities;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          String state = "";
          String sc = "";
          // var zoneData = getZoneData(suggestionsList[index]);
          // print(getZoneData(suggestionsList[index]['state']));
          setApiData();
          addToRecent(suggestionsList![index]);
          if (states.contains(suggestionsList[index])) {
            // var zoneData = getZoneData(suggestionsList[index]);
            state = suggestionsList[index];
            sc = statecode[index];
          }
          // int stateCode = getZoneData(suggestionsList[index]);
          // print(suggestionsList[index]);
          // print(state.contains(suggestionsList[index]));
          // print(getZoneData(suggestionsList[index]));

          states.contains(suggestionsList[index])
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DistrictList(state, sc),
                  ),
                )
              : getZoneData(suggestionsList[index]).isNotEmpty
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            District(getZoneData(suggestionsList[index])),
                      ),
                    )
                  : showCenterShortToast();
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggestionsList?[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                  text: suggestionsList?[index].substring(query.length),
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
      ),
      itemCount: suggestionsList != null ? suggestionsList.length : 0,
    );
  }
}
