import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data;

  void readPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = prefs.getString('name') ?? '';
    });
  }

  @override
  void initState() {
    readPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QrImageView(
            data: 'http://omishtujoy.com',
            version: QrVersions.auto,
            size: 200.0,
          ),
          data != null ? Text(data) : Text("Not Data Assigned"),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setString('name', 'Abdiwak');
            },
            child: Text('Set Data'),
          ),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              setState(() {
                data = prefs.getString('name');
              });
            },
            child: Text('Get Data'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ));
              },
              child: Text("Login"))
        ],
      ),
    );
  }
}
