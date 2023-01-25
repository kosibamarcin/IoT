import 'dart:math';

import 'package:air_humidifier/menu.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:azstore/azstore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'register_page.dart';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';
bool showError = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCotroller = TextEditingController();
  final _passwordController = TextEditingController();

  // Future signIn() async {
  // 	await getEmail()
  // }

  signIn() async {
    setState(() => showError = false);
    String providedEmail = _emailCotroller.text.trim();
    String providedPassword = _passwordController.text.trim();
    var password = sha256.convert(utf8.encode(providedPassword));
    String folder = await testGetTableRow(providedEmail, password);
    if (folder != '0') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder:
                  (context) => /*MyHomePage(
                  title: 'Home Page', email: providedEmail, folder: folder)*/
                      MenuPage(
                          title: 'Home Page',
                          email: providedEmail,
                          folder: folder)));
    }
  }

  Future<String> testGetTableRow(String email, password) async {
    var storage = AzureStorage.parse(connectionString);
    try {
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
      setState(() => showError = true);
    }
    return '0';
  }

  signUp() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(title: 'Home Page')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 214, 219),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Hello',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                'Please, log in to use your device',
                style: TextStyle(
                  fontSize: 18,
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
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    showError ? 'Wrong credentials' : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.purple[600],
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                        child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 18,
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
                      'Sign Up',
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
