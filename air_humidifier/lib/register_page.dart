import 'dart:math';

import 'package:air_humidifier/main.dart';
import 'package:flutter/material.dart';
import 'package:azstore/azstore.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';

// signUp() async {
//   Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => MyHomePage(
//                 title: 'Home Page', email: providedEmail, folder: folder)));
// }

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
      home: const RegisterPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.title});
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCotroller = TextEditingController();
  final _passwordController = TextEditingController();

  signUp() async {
    // setState(() => showError = false);
    String providedEmail = _emailCotroller.text.trim();
    String providedPassword = _passwordController.text.trim();
    var password = sha256.convert(utf8.encode(providedPassword));
    String folder = await testPutTableRow(providedEmail, password);
    if (folder != '0') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  title: 'Home Page', email: providedEmail, folder: folder)));
    }
  }

  Future<String> testPutTableRow(String email, password) async {
    var storage = AzureStorage.parse(connectionString);
    try {
      print(email);
      print(password.toString());
      Map<String, dynamic> rowMap = {
        "password": password.toString(),
        "folder": 'outcontainer'
      };
      await storage.upsertTableRow(
          tableName: 'Users',
          partitionKey: '1',
          rowKey: email,
          bodyMap: rowMap);
      String result = await storage.getTableRow(
          tableName: 'Users',
          partitionKey: '1',
          rowKey: email,
          fields: ['password', 'folder']);
      var data = jsonDecode(result);
      if (password.toString() == data["password"]) {
        return data["folder"];
      }
    } catch (e) {
      print(e.toString());
      // setState(() => showError = true);
    }
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    // List<double> list = await testDownloadImage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Create an account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 35,
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
                    controller: _emailCotroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        contentPadding: EdgeInsets.only(left: 10.0)),
                  ),
                ),
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        contentPadding: EdgeInsets.only(left: 10.0)),
                  ),
                ),
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
                    // controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Repeat password',
                        contentPadding: EdgeInsets.only(left: 10.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signUp,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.purple[600],
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                        child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
