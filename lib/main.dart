import 'dart:async';
import 'package:flutter/material.dart';

import 'package:pingpong/tabs/HomeTab.dart';
import 'package:pingpong/tabs/ChatTab.dart';
import 'package:pingpong/tabs/StatisticsTab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PingPong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new MainPage()
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  //AnimationController animation;
  //Animation<double> _fadeInFadeOut;

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    /*animation = AnimationController(vsync: this, duration: Duration(seconds: 2),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        animation.reverse();
      } else if(status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();*/

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: null,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/start.png', width:200, height:200),
              SizedBox(height: 10),
              Text('핑퐁 플래너', style: new TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          )
          /*child: FadeTransition(
            opacity: _fadeInFadeOut,
            child:
          )*/
      )
    );
  }
}

/*
body:
 */

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  //위젯의 필드들은 final 필수.
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          // set icon to the tab
          //icon: Icon(Icons.home),
          icon: Image.asset('images/icon2.png', width: 40, height: 40,)
        ),
        Tab(
            icon: Image.asset('images/icon3.png', width: 40, height: 40,)
        ),
        Tab(
            icon: Image.asset('images/icon1.png', width: 40, height: 40,)
        )
      ],
      // setup the controller
      controller: controller,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: Image.asset('images/app.jpg'),
        title: Text('이상욱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '설정',
            onPressed: () {
            },
          )
        ],
      ),
      // Set the TabBar view as the body of the Scaffold
      body: getTabBarView(<Widget>[HomeTab(), ChatScreen(), StatisticsTab()]),
      bottomNavigationBar: Container(
        child: getTabBar(),
        color: Colors.blueAccent,
      ),
    );
  }
}
