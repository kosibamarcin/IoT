import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:azstore/azstore.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'login_page.dart';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';

double _humidity = 0;
double _temparature = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: LoginPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> getData() async {
    List<double> list = await downloadData();
    _humidity = list[0];
    _temparature = list[1];
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getData(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return mainContent(context);
          } else {
            return progress();
          }
        });
  }

  progress() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              height: 50.0,
              width: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  mainContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Data',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Divider(
              color: Color.fromARGB(255, 223, 223, 223), //color of divider
              height: 35, //height spacing of divider
              thickness: 3, //thickness of divier line
              indent: 25, //spacing at the start of divider
              endIndent: 25, //spacing at the end of divider
            ),
            Text(
              'Current humidity: $_humidity%',
            ),
            const Divider(
              color: Color.fromARGB(255, 223, 223, 223), //color of divider
              height: 35, //height spacing of divider
              thickness: 3, //thickness of divier line
              indent: 25, //spacing at the start of divider
              endIndent: 25, //spacing at the end of divider
            ),
            Text(
              'Current temperature: $_temparature°C',
            )
          ],
        ),
      ),
    );
  }
}

Future<List<double>> downloadData() async {
  var storage = AzureStorage.parse(connectionString);
  List<double> list = [0, 0];
  try {
    var result =
        await storage.getBlob('/messages/iot-stm-hub/02/2022/12/23/10/58.json');
    var code = result.statusCode;
    var stream = result.stream;
    var data = jsonDecode(await stream.transform(utf8.decoder).join());
    list[0] = double.parse(data[0]["Properties"]["temperature"]);
    list[1] = double.parse(data[0]["Properties"]["humidity"]);
  } catch (e) {
    print('exception: $e');
  }
  return list;
}
