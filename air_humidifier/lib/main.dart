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

double _humidity = 50.5;
double _temparature = 44.5;

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
      home: LoginPage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      setVariables();
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<double> list = await testDownloadImage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Future<void> testUploadImage() async {
//   File testFile = File('/home/patryk/Pulpit/cat.png');
//   Uint8List bytes = testFile.readAsBytesSync();
//   var storage = AzureStorage.parse(connectionString);
//   try {
//     print("Jest ok");
//     await storage.putBlob(
//       '/messages/cat.png',
//       bodyBytes:
//           bytes, //Text can be uploaded to 'blob' in which case body parameter is specified instead of 'bodyBytes'
//       contentType: 'image/png',
//     );
//   } catch (e) {
//     print('exception: $e');
//   }
// }

Future<List<double>> testDownloadImage() async {
  var storage = AzureStorage.parse(connectionString);
  List<double> list = [0, 0];
  try {
    var result =
        await storage.getBlob('/messages/iot-stm-hub/02/2022/12/23/10/58.json');
    var code = result.statusCode;
    print("Status code: $code");
    var stream = result.stream;
    var data = jsonDecode(await stream.transform(utf8.decoder).join());
    list[0] = double.parse(data[0]["Properties"]["temperature"]);
    list[1] = double.parse(data[0]["Properties"]["humidity"]);
    print(list);
  } catch (e) {
    print('exception: $e');
  }
  return list;
}

void setVariables() async {
  List<double> list = await testDownloadImage();
  _humidity = list[0];
  _temparature = list[1];
}
