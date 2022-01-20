import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';

import '../helper.dart';

class DriveaCarDialog {
  static showJoyStickComponents(
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
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Color.fromRGBO(227, 227, 227, 1),
        insetPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07),
        child: ListView(
          physics: MediaQuery.of(context).viewInsets.bottom == 0
              ? ScrollPhysics()
              : NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Açıklama: Burada seri haberleşme de eklediğiniz koşulardaki anahtarları joystick\'in uygun yönlerine dikkat ederek boş kısımlarına giriniz. Ekstradan ön, arka far ve korna seçeneklerini de doldurabilirsiniz. ",
              ),
            ),
            Center(
              child: Container(
                width: 55,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: upFieldController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: 'Up'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                JoystickView(
                  interval: Duration(
                    milliseconds: 200,
                  ),
                  showArrows: true,
                  backgroundColor: Colors.greenAccent,
                  innerCircleColor: Colors.redAccent,
                  onDirectionChanged: (degrees, distance) {
                    // print(degrees);
                    // print(distance);

                    if (_connected && distance >= 0.5) {
                      if (degrees > 45 && degrees < 135) {
                        if (rightFieldController.text.isNotEmpty) {
                          _sendTextMessageToBluetooth(
                              rightFieldController.text);
                        }
                      } else if (degrees > 225 && degrees < 315) {
                        if (leftFieldController.text.isNotEmpty) {
                          _sendTextMessageToBluetooth(leftFieldController.text);
                        }
                      } else if ((degrees > 0 && degrees < 45) ||
                          (degrees > 315 && degrees < 360)) {
                        if (upFieldController.text.isNotEmpty) {
                          _sendTextMessageToBluetooth(upFieldController.text);
                        }
                      } else if (degrees > 135 && degrees < 225) {
                        if (downFieldController.text.isNotEmpty) {
                          _sendTextMessageToBluetooth(downFieldController.text);
                        }
                      }
                    } else {
                      if (stopFieldController.text.isNotEmpty) {
                        _sendTextMessageToBluetooth(stopFieldController.text);
                      }
                    }
                  },
                ),
                Positioned(
                  top: 130,
                  left: 20,
                  child: Container(
                    width: 55,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: stopFieldController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Stop'),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 30,
                  child: Container(
                    width: 55,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: leftFieldController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Left'),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  right: 30,
                  child: Container(
                    width: 55,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: rightFieldController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Right'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 60,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: downFieldController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: 'Down'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Ön far",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: onFarOn,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (onFarOn.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(onFarOn.text);
                              _sendTextMessageToBluetooth(onFarOn.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ON",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: onFarOff,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (onFarOff.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(onFarOn.text);
                              _sendTextMessageToBluetooth(onFarOff.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "OFF",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      "Arka far",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: arkaFarOn,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (arkaFarOn.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(onFarOn.text);
                              _sendTextMessageToBluetooth(arkaFarOn.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ON",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: arkaFarOff,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (arkaFarOff.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(onFarOn.text);
                              _sendTextMessageToBluetooth(arkaFarOff.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "OFF",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      "Korna",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: kornaOn,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (kornaOn.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(onFarOn.text);
                              _sendTextMessageToBluetooth(kornaOn.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "ON",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: kornaOff,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                hintText: 'TEST'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_connected) {
                              if (kornaOff.text.isEmpty) {
                                BluetoothHelper.show(
                                  _scaffoldKey,
                                  "Lütfen bluetooth'a göndermek için bir şeyler yaz!",
                                );
                                return;
                              }

                              print(kornaOff.text);
                              _sendTextMessageToBluetooth(kornaOff.text);
                            } else {
                              BluetoothHelper.show(
                                  _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              "OFF",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
