import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ResultPage extends StatefulWidget {
  const ResultPage({
    required this.saleAmount,
  });

  final String saleAmount;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
   
    Timer.periodic(
        const Duration(seconds: 5), (timer) => Navigator.pop(context));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ສະແດງຜົນການຈ່າຍ',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ຊຳລະເງິນສຳເລັດ',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.green,
                )
              ],
            ),
            Text(
              '${NumberFormat.decimalPattern().format(int.parse(widget.saleAmount))} ກີບ',
              style: TextStyle(fontSize: 60),
            ),
          ],
        ),
      )),
    );
  }
}
