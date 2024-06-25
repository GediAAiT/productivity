import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late TextEditingController txtWork;
  late TextEditingController txtShort;
  late TextEditingController txtLong;
  static const String WORKTIME = "workTime";
  static const String SHORTBREAK = "shortBreak";
  static const String LONGBREAK = "longBreak";
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: <Widget>[
          Text("Work", style: textStyle),
          Text(""),
          Text(""),
          SettingsButton(Colors.green, "-", -1),
          TextField(
            controller: txtWork,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(Colors.red, "+", 1),
          Text("Short", style: textStyle),
          Text(""),
          Text(""),
          SettingsButton(Colors.pinkAccent, "-", -1),
          TextField(
            controller: txtShort,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(Colors.blue, "+", 1),
          Text("Long", style: textStyle),
          Text(""),
          Text(""),
          SettingsButton(Colors.orangeAccent, "-", -1),
          TextField(
            controller: txtLong,
            style: textStyle,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          SettingsButton(Colors.purple, "+", 1),
        ],
      ),
    );
  }

  Future<void> readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int? workTime = prefs.getInt(WORKTIME);
    if (workTime == null) {
      await prefs.setInt(WORKTIME, 30);
    }
    int? shortBreak = prefs.getInt(SHORTBREAK);
    if (shortBreak == null) {
      await prefs.setInt(SHORTBREAK, 5);
    }
    int? longBreak = prefs.getInt(LONGBREAK);
    if (longBreak == null) {
      await prefs.setInt(LONGBREAK, 20);
    }
    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch (key) {
      case WORKTIME:
        if (value >= 1 && value <= 180) {
          prefs.setInt(WORKTIME, value);
          setState(() {
            txtWork.text = value.toString();
          });
        }
        break;
      case SHORTBREAK:
        if (value >= 1 && value <= 120) {
          prefs.setInt(SHORTBREAK, value);
          setState(() {
            txtShort.text = value.toString();
          });
        }
        break;
      case LONGBREAK:
        if (value >= 1 && value <= 180) {
          prefs.setInt(LONGBREAK, value);
          setState(() {
            txtLong.text = value.toString();
          });
        }
        break;
    }
  }}
class SettingsButton extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  SettingsButton(this.color, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Set the button color
      ),
      child: Text(label),
    );
  }
}
