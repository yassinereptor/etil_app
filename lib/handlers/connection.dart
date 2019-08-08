
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:toast/toast.dart';


class ConnectionCheck
{
  static lookup() async
  {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return (1);
      }
    } on SocketException catch (_) {
      return (0);
    }
  }

  static showAlert(context, String text)
  {
    Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM, backgroundColor: Colors.red);
  }

  static checkConnection(context)async
  {
    return (await checkConnectivity(context));
  }

  static checkConnectivity(context) async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if(await lookup() == 0)
      {
        showAlert(context,"Check your mobile connection!");
        return (0);
      }
      else
        return (1);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if(await lookup() == 0)
      {
        showAlert(context,"Check your wifi connection!");
        return (0);
      }
      else
        return (1);
    }
    else if (connectivityResult == ConnectivityResult.none)
    {
      showAlert(context,"No connection internet!");
      return (0);
    }
  }
}