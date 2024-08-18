import 'package:tracker_app/pages/emission_page.dart';
import 'package:tracker_app/pages/settings_page.dart';
import 'package:tracker_app/pages/stats_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List pages = [
    const StatsPage(),
    const EmissionPage(),
    const SettingsPage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          currentIndex: selectedIndex,
          
          onTap: (int index) => {
            setState(() {
              selectedIndex = index;
            })
          },
          selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer),
              label: "Stats" ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: "Emissions"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings), 
              label: "Settings"),
          ],
        ),
    );
  }
}