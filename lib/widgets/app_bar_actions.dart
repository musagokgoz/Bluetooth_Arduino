import 'package:flutter/material.dart';

import '../helper.dart';

class AppBarActions {
  static appBarActions(getPairedDevices, _scaffoldKey) {
    return Column(
      children: [
        FlatButton.icon(
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          label: Text(
            "Yenile",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          //splashColor: Colors.deepPurple,
          onPressed: () async {
            // So, that when new devices are paired
            // while the app is running, user can refresh
            // the paired devices list.
            await getPairedDevices().then((_) {
              BluetoothHelper.show(_scaffoldKey, ' Cihazlar yenilendi');
            });
          },
        ),
      ],
    );
  }
}
