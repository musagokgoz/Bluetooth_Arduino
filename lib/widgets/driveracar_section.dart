import 'package:bluetooth/widgets/driveacar_dialog.dart';
import 'package:flutter/material.dart';

class DriveraCarSection {
  static driveaCar(
    context,
    onFarOn,
    arkaFarOn,
    onFarOff,
    arkaFarOff,
    kornaOn,
    kornaOff,
    stopFieldController,
    upFieldController,
    rightFieldController,
    leftFieldController,
    downFieldController,
    Function _sendTextMessageToBluetooth,
    _connected,
    _scaffoldKey,
  ) {
    return Column(
      children: [
        Divider(),
        Text(
          "Drive a Car",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 20),
        IconButton(
          iconSize: 100,
          onPressed: () {
            return DriveaCarDialog.showJoyStickComponents(
              context,
              onFarOn,
              arkaFarOn,
              onFarOff,
              arkaFarOff,
              kornaOn,
              kornaOff,
              stopFieldController,
              upFieldController,
              rightFieldController,
              leftFieldController,
              downFieldController,
              _sendTextMessageToBluetooth,
              _connected,
              _scaffoldKey,
            );
          },
          icon: Image.asset(
            'assets/images/araba.png',
          ),
        ),
      ],
    );
  }
}
