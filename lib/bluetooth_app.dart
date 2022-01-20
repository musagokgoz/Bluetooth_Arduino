import 'dart:async';
import 'dart:convert';

import 'package:bluetooth/advert-service.dart';
import 'package:bluetooth/widgets/driveracar_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'helper.dart';
import 'widgets/app_bar_actions.dart';
import 'widgets/get_device_items.dart';
import 'widgets/joystick_section.dart';
import 'widgets/led_test_dialog.dart';
import 'widgets/send_serial_dialog.dart';
import 'widgets/settings_section.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection connection;

  int _deviceState;

  bool isDisconnecting = false;

  final textFieldController = TextEditingController();

  final testLEDONFieldController = TextEditingController();
  final testLEDOFFFieldController = TextEditingController();

  final upFieldController = TextEditingController();
  final downFieldController = TextEditingController();
  final rightFieldController = TextEditingController();
  final leftFieldController = TextEditingController();
  final stopFieldController = TextEditingController();
  final onFarOn = TextEditingController();
  final arkaFarOn = TextEditingController();
  final onFarOff = TextEditingController();
  final arkaFarOff = TextEditingController();
  final kornaOn = TextEditingController();
  final kornaOff = TextEditingController();

  bool checkIfPressing = false;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;
  bool baglantiKurulamadiyaGirdi = false;
  final AdvertService _advertService = AdvertService();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    BluetoothHelper.enableBluetooth(_bluetoothState, getPairedDevices);

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  int reklamSayaci = 0;
  int reklamSayaci2 = 0;

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    setState(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Bluetooth arduino"),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            AppBarActions.appBarActions(getPairedDevices, _scaffoldKey),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(14),
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Bluetooth\'u etkinleştir',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Eşleşmiş cihazlar",
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Cihazlar:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: DropdownButton(
                        isExpanded: true,
                        items: GetDeviceItems.getDeviceItems(_devicesList),
                        onChanged: (value) => setState(() => _device = value),
                        value: _devicesList.isNotEmpty ? _device : null,
                      ),
                    ),
                    RaisedButton(
                      onPressed: _isButtonUnavailable
                          ? null
                          : _connected
                              ? _disconnect
                              : _connect,
                      child: Text(_connected ? 'Kes' : 'Bağlan'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Test LED",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
              ),
              IconButton(
                iconSize: 100,
                icon: Image.asset(
                  'assets/images/led.png',
                ),
                onPressed: () {
                  if (reklamSayaci % 2 == 1) {
                    setState(() {
                      _advertService.showIntersitial();
                    });
                  }
                  reklamSayaci++;

                  return LedTestDialog.showLedTestDialog(
                      context,
                      _deviceState,
                      testLEDONFieldController,
                      testLEDOFFFieldController,
                      _connected,
                      _scaffoldKey,
                      _sendTextMessageToBluetooth);
                },
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Sending To Bluetooth",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(
                  iconSize: 100,
                  icon: Image.asset(
                    'assets/images/chat.png',
                  ),
                  onPressed: () {
                    if (reklamSayaci2 % 2 == 1) {
                      setState(() {
                        _advertService.showIntersitial();
                      });
                    }
                    reklamSayaci2++;
                    return SendSerialDialog.showSerialDialog(
                      context,
                      textFieldController,
                      _connected,
                      _scaffoldKey,
                      _sendTextMessageToBluetooth,
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              DriveraCarSection.driveaCar(
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
              ),
              SizedBox(height: 20),
              JoyStickSection.joyStick(
                  context,
                  upFieldController,
                  rightFieldController,
                  leftFieldController,
                  downFieldController,
                  _sendTextMessageToBluetooth,
                  _connected),
              SettingSection.settingSection(),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      BluetoothHelper.show(_scaffoldKey, ' Cihaz seçili değil!');
      setState(() => _isButtonUnavailable = false);
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          BluetoothHelper.show(_scaffoldKey, ' Bağlantı Kuruldu :)');
          setState(() => _isButtonUnavailable = false);
          print('Connected to the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              BluetoothHelper.show(_scaffoldKey, ' Bağlantı Kesildi!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          baglantiKurulamadiyaGirdi = true;
          BluetoothHelper.show(_scaffoldKey,
              ' Bağlantı Kurulamadı.\n { Cihazın açık olduğundan ve \n doğru cihaz seçili olduğundan emin olun!!! }');
          setState(() => _isButtonUnavailable = false);
          print(error);
        });
      }
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _deviceState = 0;
    });

    await connection.close();

    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  void _sendTextMessageToBluetooth(String message) async {
    connection.output.add(utf8.encode(message + "\r\n"));
    await connection.output.allSent;

    setState(() {
      _deviceState = -1; // device off
    });
  }

// Method to show a Snackbar,
// taking message as the text

}
