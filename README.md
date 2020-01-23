Usage sample:

import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool sim = false;
  ButtonState acutalState = ButtonState.INITIAL_STATE;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Button Test"),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                FlatButton(
                  child: Text('End'),
                  onPressed: () {
                    setState(() {
                      acutalState = ButtonState.END_LOADING_STATE;
                    });
                  },
                ),
                FlatButton(
                  child: Text('Initial'),
                  onPressed: () {
                    setState(() {
                      acutalState = ButtonState.INITIAL_STATE;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: CommonButton(
                      onTap: () {
                        setState(() {
                          acutalState = ButtonState.START_LOADING_STATE;
                        });
                      },
                      buttonText: 'Teste',
                      buttonColor: Colors.white,
                      loadingAnimation: true,
                      buttonState: acutalState,
                      animationDuration: Duration(milliseconds: 600),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                  ),
                ),
              ],
            )));
  }
}
