import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

 final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  Future<void> btnSet() async {
   // Obtain shared preferences.
final prefs = await SharedPreferences.getInstance();
 final int counter = prefs.getInt('btn1') ?? 0;

await prefs.setInt('btn1', 1000);

  
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('counter') ?? 0;
    });
  }
  @override
  
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("data"),);
  }
}