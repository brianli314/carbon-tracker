import 'package:provider/provider.dart';
import 'package:tracker_app/pages/emission_page.dart';
import 'package:tracker_app/pages/quiz_page.dart';
import 'package:tracker_app/pages/settings_page.dart';
import 'package:tracker_app/pages/setup_page.dart';
import 'package:tracker_app/pages/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/services/database_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  final bool _isLoading = true;

  int selectedIndex = 0;

  final List pages = [
    const StatsPage(),
    const EmissionPage(),
    const QuizPage(),
    SettingsPage(),
  ];

  final List<BottomNavigationBarItem> iconPages = const [
    BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: "Stats"),
    BottomNavigationBarItem(icon: Icon(Icons.public), label: "Emissions"),
    BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Fun Facts"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
    
  ];

  final List setupPages = [const SetupPage(), SettingsPage(showLogout: false,)];

  final List<BottomNavigationBarItem> iconSetup = const [
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Setup"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
  ];

  /*
  @override
  void initState(){
    super.initState();
    loadSetup();
    setState(() {
      _isLoading = false;
    });
  }

  void loadSetup() async {
    await databaseProvider.loadData(FirebaseAuth.instance.currentUser!.uid);
  }
  */

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        currentIndex: selectedIndex,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        
        onTap: (int index) => {
          setState(() {
            selectedIndex = index;
          })
        },
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        items: iconPages,
      ),
    );
  }
}
