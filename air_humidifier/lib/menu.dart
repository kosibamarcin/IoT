import 'package:air_humidifier/main.dart';
import 'package:flutter/material.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MenuPage> {
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

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
            Text("Select your device!"),
            DropdownButton(
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            ElevatedButton(
              child: const Text('CONFIRM'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          title: "${widget.title}",
                          email: "${widget.email}",
                          folder: "${widget.folder}")),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
