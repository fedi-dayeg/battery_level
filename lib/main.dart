import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IconData iconSwitch = Icons.battery_unknown;

  static const MethodChannel methodChannel =
      MethodChannel('app.flutter.io/battery');
  static const EventChannel eventChannel =
      EventChannel('app.flutter.io/charging');

  String _batteryLevel = 'Battery level: Unknown';
  String _chargingStatus = 'Battery status: Unknown';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level : $result';
    } on PlatformException {
      batteryLevel = 'Failed to get battery level';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      _chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging";
      iconSwitch = (event == 'charging')
          ? Icons.battery_charging_full
          : Icons.battery_full;
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.amber,
                fontSize: 26.0,
                fontWeight: FontWeight.w700)),
        scaffoldBackgroundColor: Colors.black38,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
                color: Colors.amber,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          color: Colors.black38,
          elevation: 0.0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Platform Chanel example'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                _batteryLevel,
                key: const Key('Battery level Label'),
              ),
              FlatButton(
                onPressed: _getBatteryLevel,
                child: Icon(
                  iconSwitch,
                  size: 290.0,
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(_chargingStatus),
            ],
          ),
        ),
      ),
    );
  }
}
