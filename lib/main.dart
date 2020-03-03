import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const platform = const MethodChannel('duosdk.microsoft.dev');

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
           primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cTimeH;
  int cTimeM;
  int cTimeS;

  Timer _timer;
  static Duration tickDuration = const Duration(milliseconds: 1000);

  bool isSpanned = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(tickDuration, _updateTime);

  }

  void _updateTime(Timer timeStamp) {
    setState(() {

      cTimeH = DateTime.now().hour;
      //print(cTimeH);

      cTimeM = DateTime.now().minute;
     // print(cTimeM);

      cTimeS = DateTime.now().second;
      //print(cTimeS);
    });
  }


  @override
  void dispose() {

    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
  void _updateDualScreenInfo() async {
    //bool isDual = await platform.invokeMethod('isDualScreenDevice');
    isSpanned = await platform.invokeMethod('isAppSpanned');
    //print('isAppSpanned : $isSpanned');
  }

  @override
  Widget build(BuildContext context) {
    _updateDualScreenInfo();
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
         title: Text(widget.title),
      ),
      body: Center(
         child: Stack(

          children: <Widget>[
            Positioned(
              height: 300,
              top: height * .35,
              left: isSpanned ? width * .38 : width * .40,
              child:  Text(
                '$cTimeH:',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Positioned(
              height: 300,
              top: height * .35,
              left: isSpanned ? width * .43 : width * .5,
              child:  Text(
                '$cTimeM:',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Positioned(
              height: 300,
              top: height * .35,
              left: isSpanned ? width * .53 : width * .60,
              child:  Text(
                '$cTimeS',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
        // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
