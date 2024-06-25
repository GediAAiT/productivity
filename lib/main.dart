import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productivity_timer/timermodel.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import './timer.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Work Timer',
      theme: ThemeData(
        colorSchemeSeed: Colors.purpleAccent,
        appBarTheme: const AppBarTheme(elevation: 0),
        useMaterial3: false,
      ),
      home: TimerHomePage(),
    );}
}
class TimerHomePage extends StatelessWidget{
  final double defaultPadding = 5.0;

  final CountDownTimer timer = CountDownTimer();
  @override

  Widget build(BuildContext context){
    final List<PopupMenuItem<String>> menuItems = [
      const PopupMenuItem<String>(
        value: 'Settings',
        child: Text('Settings'),
      ),
    ];

    timer.startWork();
    return MaterialApp(
        title: 'My Work Timer',
        theme: ThemeData(
          colorSchemeSeed: Colors.purpleAccent,
          appBarTheme: const AppBarTheme(elevation: 0),
          useMaterial3: false,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('My Work Timer'),
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) {
                  return menuItems.toList();
                },
                onSelected: (s) {
                  if(s=='Settings') {
                    goToSettings(context);
                  }
                },
              )
            ],
          ),
          body: LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints){
            final double availableWidth = constraints.maxWidth;
            return Column(
                children:[ Row(
                  children: [Padding(padding: EdgeInsets.all(defaultPadding),),
                    Expanded(child: ProductivityButton(color: Colors.green,
                      text: "work", onPressed: () => timer.startWork(), size: 5.0,)),
                    Padding(padding: EdgeInsets.all(defaultPadding),),
                    Expanded(child: ProductivityButton(color: Colors.redAccent,
                      text: "short Break", onPressed: () => timer.startBreak(true), size: 5.0,)),
                    Padding(padding: EdgeInsets.all(defaultPadding),),
                    Expanded(child: ProductivityButton(color: Colors.orangeAccent,
                      text: "long Break", onPressed: ()=> timer.startBreak(false), size: 5.0,)),
                    Padding(padding: EdgeInsets.all(defaultPadding),),],
                ),
                  Expanded(
                      child: StreamBuilder(
                          initialData: TimerModel('00:00', 1),
                          stream: timer.stream(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            TimerModel timer = snapshot.data;
                            return Container(
                                child: CircularPercentIndicator(
                                  radius: availableWidth / 2,
                                  lineWidth: 10.0,
                                  percent: (timer.percent == null) ? 1 : timer.percent,
                                  center: Text( (timer.time == null) ? '00:00' : timer.time ,
                                      style: Theme.of(context).textTheme.headlineMedium),
                                  progressColor: Colors.orange,
                                ));
                          })),

                  Row(children: [
                    Padding(padding: EdgeInsets.all(defaultPadding),),
                    Expanded(child: ProductivityButton(color: Colors.red,
                      text: 'Stop', onPressed: () => timer.stopTimer(), size: 5.0,)),
                    Padding(padding:
                    EdgeInsets.all(defaultPadding),),
                    Expanded(child: ProductivityButton(color: Colors.lightGreen,
                      text: 'Restart', onPressed: ()=> timer.startTimer(), size: 5.0,)),
                    Padding(padding: EdgeInsets.all(defaultPadding),),
                  ],)
                ]);
          }),

        ));

  }
  void emptyMethod() {}
  void goToSettings(BuildContext context) {
    print('in gotoSettings');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}