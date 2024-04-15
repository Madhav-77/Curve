import 'dart:async';
//import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:Curve/custom_navigation.dart';
import 'package:Curve/shared/no_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/foundation.dart';

class ConnectionCheck extends StatefulWidget {
  @override
  _ConnectionCheckState createState() => _ConnectionCheckState();
}

class _ConnectionCheckState extends State<ConnectionCheck> {
  String _connectionStatus = 'Unknown';
  bool isConnectionActive = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return NoInternet();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() => isConnectionActive = true);
        break;
      case ConnectivityResult.none:
        setState(() {
          isConnectionActive = false;
          _connectionStatus = "Please check your internet connection";
        });
        break;
      default:
        setState(() {
          isConnectionActive = false;
          _connectionStatus = "Failed to connect, please try again after sometime";
        });
        break;
    }
  }
}