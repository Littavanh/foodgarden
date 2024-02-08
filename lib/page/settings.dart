import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../source/source.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController T_controller;
  late TextEditingController T_controller2;
  late TextEditingController T_controller3;
  late TextEditingController T_controller4;
  late TextEditingController T_controller5;
  late TextEditingController T_controller6;
  late TextEditingController T_controller7;
  late TextEditingController T_controller8;
  late TextEditingController T_controller9;
  late TextEditingController T_controllerPrint_count;
  late TextEditingController T_url;
  String btn_1 = '';
  String btn_2 = '';
  String btn_3 = '';
  String btn_4 = '';
  String btn_5 = '';
  String btn_6 = '';
  String btn_7 = '';
  String btn_8 = '';
  String btn_9 = '';
  String btn_url = '';
  int btn_p = 1;

  loadQuickButton() async {
    var pref = await SharedPreferences.getInstance();

    setState(() {
      btn_1 = pref.getString("num_1") ?? "1000";
      btn_2 = pref.getString("num_2") ?? "5000";
      btn_3 = pref.getString("num_3") ?? "10000";
      btn_4 = pref.getString("num_4") ?? "15000";
      btn_5 = pref.getString("num_5") ?? "20000";
      btn_6 = pref.getString("num_6") ?? "30000";
      btn_7 = pref.getString("num_7") ?? "50000";
      btn_8 = pref.getString("num_8") ?? "70000";
      btn_9 = pref.getString("num_9") ?? "100000";
      btn_p = pref.getInt("print_count") ?? 1;
      btn_url = pref.getString("url") ?? UrlConstants.initURL;

      T_controller = TextEditingController(text: btn_1);
      T_controller2 = TextEditingController(text: btn_2);
      T_controller3 = TextEditingController(text: btn_3);
      T_controller4 = TextEditingController(text: btn_4);
      T_controller5 = TextEditingController(text: btn_5);
      T_controller6 = TextEditingController(text: btn_6);
      T_controller7 = TextEditingController(text: btn_7);
      T_controller8 = TextEditingController(text: btn_8);
      T_controller9 = TextEditingController(text: btn_9);
      T_controllerPrint_count = TextEditingController(text: btn_p.toString());
      T_url = TextEditingController(text: btn_url);
    });

    print("loadQuickButton ===> button3: $btn_3 ,url: $btn_url");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadQuickButton();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ການຕັ້ງຄ່າ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // ignore: prefer_const_literals_to_create_immutables
        child: ListView(children: [
          const Text("ປຸ່ມຈຳນວນເງິນດ່ວນ"),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ1"),
            subtitle: Text(btn_1),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ2"),
            subtitle: Text(btn_2),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller2,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences2();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ3"),
            subtitle: Text(btn_3),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller3,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences3();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ4"),
            subtitle: Text(btn_4),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller4,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences4();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ5"),
            subtitle: Text(btn_5),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller5,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences5();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ6"),
            subtitle: Text(btn_6),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller6,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences6();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ7"),
            subtitle: Text(btn_7),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller7,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences7();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ8"),
            subtitle: Text(btn_8),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller8,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences8();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ປຸ່ມ9"),
            subtitle: Text(btn_9),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controller9,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_Preferences9();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("ຈຳນວນໃບບິນ"),
            subtitle: Text(btn_p.toString()),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_controllerPrint_count,
                            decoration: const InputDecoration(
                              labelText: 'ກະລຸນາປ້ອນຈຳນວນ....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_PreferencesPrint_count();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("URL"),
            subtitle: Text(btn_url),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                            keyboardType: TextInputType.number,
                            controller: T_url,
                            decoration: const InputDecoration(
                              labelText: 'url....',
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _saveToShared_PreferencesUrl();
                            },
                            child: Text("ບັນທຶກ"))
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }

  _saveToShared_Preferences() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_1", T_controller.text.toString());
    setState(() {
      btn_1 = T_controller.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_Preferences2() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_2", T_controller2.text.toString());

    setState(() {
      btn_2 = T_controller2.text;
    });

    Navigator.pop(context);
  }

  _saveToShared_Preferences3() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_3", T_controller3.text.toString());

    setState(() {
      btn_3 = T_controller3.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_Preferences4() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_4", T_controller4.text.toString());

    setState(() {
      btn_4 = T_controller4.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_Preferences5() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_5", T_controller5.text.toString());

    setState(() {
      btn_5 = T_controller5.text;
    });

    Navigator.pop(context);
  }

  _saveToShared_Preferences6() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_6", T_controller6.text.toString());

    setState(() {
      btn_6 = T_controller6.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_Preferences7() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_7", T_controller7.text.toString());
    setState(() {
      btn_7 = T_controller7.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_Preferences8() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_8", T_controller8.text.toString());

    setState(() {
      btn_8 = T_controller8.text;
    });

    Navigator.pop(context);
  }

  _saveToShared_Preferences9() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("num_9", T_controller9.text.toString());

    setState(() {
      btn_9 = T_controller9.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_PreferencesUrl() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("url", T_url.text.toString());

    setState(() {
      btn_url = T_url.text;
    });
    Navigator.pop(context);
  }

  _saveToShared_PreferencesPrint_count() async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt("print_count", int.parse(T_controllerPrint_count.text));

    setState(() {
      btn_p = int.parse(T_controllerPrint_count.text);
    });
    Navigator.pop(context);
  }
}
