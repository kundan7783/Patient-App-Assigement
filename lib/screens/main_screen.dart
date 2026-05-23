import 'package:flutter/material.dart';

import 'add_patient_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    HomeScreen(),
    AddPatientScreen(
      onSuccess: () {
        setState(() {
          currentIndex = 0;
        });
      },
    ),
  ];

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF3FF),

      body: screens[currentIndex],

      // ================= PRO BOTTOM NAV =================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeTab,

          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xff2F6DF6),
          unselectedItemColor: Colors.grey,

          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),

          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: "Add Patient",
            ),
          ],
        ),
      ),
    );
  }
}