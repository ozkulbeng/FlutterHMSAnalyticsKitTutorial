import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_analytics/huawei_analytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HMSAnalytics hmsAnalytics = new HMSAnalytics();

  TextEditingController _controller = TextEditingController();
  int randomNumber;
  int guess;
  bool _isFound = false;
  String _message = "";
  int _count = 0;

  Future<void> _enableLog() async {
    await hmsAnalytics.enableLog();
  }

  Future<void> _sendEvent(int count) async {
    String name = "USERS_RESULTS";
    Map<String, String> value = {
      'number_of_guesses': count.toString(),
      'range' : getRangeFromCount(count)
    };
    await hmsAnalytics.onEvent(name, value);
  }

  @override
  void initState() {
    _enableLog();
    randomNumber = _setRandomNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HMS Analytics Kit Example"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter Your Guess [0-99]",
                border: new OutlineInputBorder(borderSide: BorderSide()),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                guess = int.parse(value);
              },
              enabled: _isFound ? false : true,
            ),
            RaisedButton(
              child: Text("OK!"),
              onPressed: () {
                if (!_isFound) {
                  _controller.text = "";
                  _count++;
                  _compareValues();
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            _isFound
                ? IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        randomNumber = _setRandomNumber();
                        _isFound = false;
                        _count = 0;
                        _message = "";
                      });
                    },
                  )
                : Text("")
          ],
        ),
      ),
    );
  }

  _compareValues() {
    if (guess == randomNumber) {
      setState(() {
        _isFound = true;
        _message =
            "Correct! The number was $randomNumber.\nYou guessed it in $_count times.";
      });
      _sendEvent(_count); //We know that user guessed the number right.
    } else if (guess > randomNumber) {
      setState(() {
        _message = "Lower!";
      });
    } else {
      setState(() {
        _message = "Higher!";
      });
    }
  }
}

_setRandomNumber() {
  Random random = Random();
  int number = random.nextInt(100); // from 0 to 99 included
  return number;
}

String getRangeFromCount(int count) {
  if (count <= 5) {
    return "1-5";
  } else if (count <= 10) {
    return "6-10";
  } else
    return "10+";
}
