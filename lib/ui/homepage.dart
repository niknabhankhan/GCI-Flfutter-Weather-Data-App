import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context) {
        return new ChangePlace();
      }),
    );
    if ( results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];


    }
  }

  void showStuff() async {
    Map data = await getWeatherData(util.apiId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: new AppBar(
        title: new Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.cloud),
              onPressed: () { _goToNextScreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.90),
            child: new Text(
              '${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: placeStyle(),
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
            child: updateWidget(_cityEntered),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeatherData(String appId, String city) async {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.apiId}&units=metric';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);

  }

  Widget updateWidget(String city) {
    return new FutureBuilder(
      future: getWeatherData(util.apiId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          if (snapshot.hasData) {
            Map content = snapshot.data;
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        content['main']['temp'].toString() +" F",
                        style: weatherStyle(),
                      ),
                      subtitle: new ListTile(
                        title: new Text(
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                              "Min: ${content['main']['temp_min'].toString()} F\n"
                              "Max: ${content['main']['temp_max'].toString()} F\n",

                          style: moreDataStyle(),

                        ),
                      ),
                    ),
                  ],
                ),
              );
          }else {
            return new Container();
          }

      });
  }
}

class ChangePlace extends StatefulWidget {
  @override
  _ChangePlaceState createState() => _ChangePlaceState();
}

class _ChangePlaceState extends State<ChangePlace> {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change Place'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'enter': _cityFieldController.text,
                    });
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Get Weather'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle placeStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle moreDataStyle() {
  return new TextStyle(
    color: Colors.white70,
    fontSize: 17.0,
    fontStyle: FontStyle.normal,
  );
}

TextStyle weatherStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}