import 'package:flutter/material.dart';
import 'main.dart';
import 'package:azstore/azstore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'register_page.dart';

const connectionString =
    'DefaultEndpointsProtocol=https;AccountName=devicemessages12;AccountKey=jfyoNHVw54+5yjC17N2JGFYvknwoUnY9t8YE4UBluHGfuor88+xwlBYOuT/ejuBBeC2MkzoUtkzq+AStZwffPQ==;EndpointSuffix=core.windows.net';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showError = false;

  signIn() async {
    setState(() => showError = false);
    String providedEmail = _emailController.text.trim();
    String providedPassword = _passwordController.text.trim();
    var password = sha256.convert(utf8.encode(providedPassword));
    String folder = await testGetTableRow(providedEmail, password);
    if (folder != '0') {
      navigateToMainPage(providedEmail, folder);
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
      } else {
        return '0';
      }
    } catch (e) {
      setState(() => showError = true);
      return '0';
    }
  }

  signUp() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterPage(title: 'Sign up')));
  }

  navigateToMainPage(String providedEmail, String folder) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Home Page', email: providedEmail, folder: folder)));
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
                const Text(
                  'Hello',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  'Please, log in to use your device',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
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
                      controller: _emailController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          contentPadding: EdgeInsets.only(left: 10.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 228, 243),
                      border: Border.all(
                        color: const Color.fromARGB(255, 238, 229, 239),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          contentPadding: EdgeInsets.only(left: 10.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      showError ? 'Wrong credentials' : '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(13)),
                      child: const Center(
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
                const SizedBox(
                  height: 30,
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
                      child: const Center(
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
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 18,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
