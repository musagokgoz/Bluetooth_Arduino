import 'package:flutter/material.dart';

import '../helper.dart';

class SendSerialDialog {
  static showSerialDialog(context, textFieldController, _connected,
      _scaffoldKey, Function _sendTextMessageToBluetooth) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
          backgroundColor: Color.fromRGBO(227, 227, 227, 1),
          insetPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  children: [
                    Text(
                      "Açıklama: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Burada seri haberleşme de eklediğiniz koşuldaki anahtarı giriniz.",
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                elevation: 10,
                child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: InputBorder.none,
                      hintText: 'bluetooth\'a göndermek için bişeyler yaz'),
                  onSubmitted: (value) {
                    if (_connected) {
                      if (value.isEmpty) {
                        BluetoothHelper.show(_scaffoldKey,
                            "Lütfen bluetooth'a göndermek için bir şeyler yaz!");
                        return;
                      }
                      print(value);
                      print(textFieldController.text);
                      _sendTextMessageToBluetooth(value);
                      textFieldController.clear();
                    } else {
                      BluetoothHelper.show(
                          _scaffoldKey, "Lütfen bir cihaz bağlayınız!");
                    }
                  },
                ),
              )
            ],
          )),
    );
  }
}
