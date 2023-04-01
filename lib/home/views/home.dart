import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renrakusen/contact_list/views/contact_list.dart';

import '../../dialer_screen/views/home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;

  List<Widget> screens = [
    const ContactList(),
    const DialerScreen(),
    const SizedBox()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff5324fd),
        elevation: 0,
        title: Text(
          "Contacts",
          style: GoogleFonts.bitter(),
        ),
      ),
      body: screens[_currentIndex],
      floatingActionButton: Visibility(
        visible: _currentIndex != 1,
        child: FloatingActionButton(
          backgroundColor: const Color(0xff5324fd),
          onPressed: () {
            setState(() {
              _currentIndex = 1;
            });
          },
          child: const Icon(Icons.phone),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.contacts),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.view_list),
              onPressed: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
