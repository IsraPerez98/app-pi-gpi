import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:micu/screens/chat_screen.dart';
import 'package:micu/screens/record_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 1;
  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
      RecordScreen(),
      ChatScreen(),
      RecordScreen()
      // HomeScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.mic_rounded), label: "Grabar"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Traducir'),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.database), label: 'Grabaciones'),
        ],
        elevation: 0,
        currentIndex: _index,
        onTap: (int newValue) {
          setState(() {
            _index = newValue;
          });
        },
      ),
    );
  }
}
