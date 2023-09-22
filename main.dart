import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OtherNews.dart';
import 'Today.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  int selected_index = 0;
  bool _isDarkmode = false;

  void toggleTheme() {
    setState(() {
      _isDarkmode = !_isDarkmode;
    });
  }

  List<Widget> pages = [
    OtherNews(),
    Today(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode:
          _isDarkmode ? ThemeMode.light : ThemeMode.dark, // Keep this line
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: Text("News Using API"),
          actions: [
            IconButton(
              icon: _isDarkmode // Update icon based on _isDarkmode
                  ? Icon(Icons.dark_mode)
                  : Icon(Icons.light_mode),
              onPressed: () {
                toggleTheme();
              },
            )
          ],
        ),
        body: Center(
          child: Container(
            child: pages.elementAt(selected_index),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.deepOrangeAccent,
          currentIndex: selected_index,
          items: [
            BottomNavigationBarItem(
                label: "Latest", icon: Icon(Icons.home_outlined)),
            BottomNavigationBarItem(
                label: "Highlights", icon: Icon(Icons.airport_shuttle))
          ],
          onTap: (int index) {
            setState(() {
              selected_index = index;
            });
          },
        ),
      ),
    );
  }
}
