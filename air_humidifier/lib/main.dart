import 'package:flutter/material.dart';
import 'package:azstore/azstore.dart';
import 'dart:async';
import 'dart:convert';
import 'login_page.dart';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LoginPage());
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String email;
  final String folder;

  MyHomePage(
      {super.key,
      required this.title,
      required this.email,
      required this.folder});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _humidity = 0;
  double _temperature = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getData(widget.folder),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return mainContent(context);
          } else {
            return progress();
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> getData(String folder) async {
    List<double> list = await downloadData(folder);
    if (!mounted) return '0';
    setState(() => _humidity = list[0]);
    setState(() => _temperature = list[1]);
    return '0';
  }

  Future<List<double>> downloadData(String folder) async {
    var storage = AzureStorage.parse(connectionString);
    List<double> list = [0, 0];
    try {
      var result = await storage.getBlob('$folder/data_ready.json');
      var stream = result.stream;
      var data = jsonDecode(await stream.transform(utf8.decoder).join());
      list[0] = double.parse(data["Properties"]["temperature"]);
      list[1] = double.parse(data["Properties"]["humidity"]);
    } catch (e) {
      print('exception: $e');
    }
    return list;
  }

  progress() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
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
              "Welcome ${widget.email}!",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 150,
            ),
            Text(
              'Data',
              style: Theme.of(context).textTheme.headline5,
            ),
            const Divider(
              color: Color.fromARGB(255, 223, 223, 223),
              height: 35,
              thickness: 3,
              indent: 25,
              endIndent: 25,
            ),
            Text(
              'Current humidity: $_humidity%',
            ),
            const Divider(
              color: Color.fromARGB(255, 223, 223, 223),
              height: 35,
              thickness: 3,
              indent: 25,
              endIndent: 25,
            ),
            Text(
              'Current temperature: $_temperature°C',
            ),
          ],
        ),
      ),
    );
  }
}
