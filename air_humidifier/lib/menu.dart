import 'package:air_humidifier/login_page.dart';
import 'package:air_humidifier/main.dart';
import 'package:flutter/material.dart';
import 'package:azstore/azstore.dart';
import 'dart:convert';
import 'dart:async';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';

class MenuPage extends StatefulWidget {
  final String title;
  final String email;
  final String folder;
  const MenuPage(
      {super.key,
      required this.title,
      required this.email,
      required this.folder});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Initial Selected Value
  final _deviceController = TextEditingController();
  bool showError = false;

  getDevice() async {
    print('trying');
    String deviceName = _deviceController.text.trim();
    String folder = await getDevicesFolder(deviceName);
    if (folder != '0') {
      await updateUsersFolder(folder);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<String> getDevicesFolder(String deviceName) async {
    var storage = AzureStorage.parse(connectionString);
    try {
      String result = await storage.getTableRow(
          tableName: 'Devices',
          partitionKey: '1',
          rowKey: deviceName,
          fields: ['folder']);
      var data = jsonDecode(result);
      setState(() => showError = false);
      return data['folder'];
    } catch (e) {
      setState(() => showError = true);
      return '0';
    }
  }

  Future<String> updateUsersFolder(String folder) async {
    var storage = AzureStorage.parse(connectionString);
    try {
      Map<String, dynamic> rowMap = {"folder": folder};
      await storage.upsertTableRow(
          tableName: 'Users',
          partitionKey: '1',
          rowKey: widget.email,
          bodyMap: rowMap);
      return '1';
    } catch (e) {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.email}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Provide your device's name!",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 228, 243),
                  border: Border.all(
                    color: Color.fromARGB(255, 238, 229, 239),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _deviceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Device name',
                      contentPadding: EdgeInsets.only(left: 10.0)),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  showError ? 'Wrong device name' : '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: const Text('CONFIRM'),
              onPressed: () {
                getDevice();
              },
            ),
          ],
        ),
      ),
    );
  }
}
