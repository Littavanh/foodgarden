import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SP extends StatefulWidget {
  const SP({super.key});

  @override
  State<SP> createState() => _SPState();
}

class _SPState extends State<SP> {
  int? _num1;
  void loadNumber() async {
// Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

// Save an integer value to 'counter' key.
    await prefs.setInt('num1', 1000);
    setState(() {
      // Try reading data from the 'counter' key. If it doesn't exist, returns null.
      final int num1 = prefs.getInt('num1') ?? 0;
      _num1 = num1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         drawer: Drawer(
          child: ListView(children: [
            DrawerHeader(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("header"),
                    Text("ລະຫັດ: no"),
                  ],
                )),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.settings),
                  Text("ການຕັ້ງຄ່າ"),
                ],
              ),
              onTap: () {
                
              },
            ),
           
          ]),
        ),
      appBar: AppBar(title: Text("data")),
      body: Column(
        children: [
          Container(
            child: Text(_num1.toString()),
            width: 200,
            height: 100,
            color: Colors.red,
          ),
          Container(
            width: 200,
            height: 100,
            color: Colors.green,
          ),
          Container(
            width: 200,
            height: 100,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
