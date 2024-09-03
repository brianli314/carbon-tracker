import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/components/bar_graph.dart';
import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/loading_circle.dart';
import 'package:tracker_app/pages/test_page.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/units.dart';

class EmissionPage extends StatefulWidget {
  const EmissionPage({super.key});

  @override
  State<EmissionPage> createState() => _EmissionPageState();
}

class _EmissionPageState extends State<EmissionPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = [
    const Tab(text: "Week"),
    const Tab(text: "Year"),
  ];

  String uid = FirebaseAuth.instance.currentUser!.uid;
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  bool _isLoading = true;
  DateTime today = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadStats();
  }

  Future<void> loadStats() async {
    await databaseProvider.loadData(uid);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    List<int> months = [
      for (int i = 11; i >= 0; i--) Jiffy.now().subtract(months: i).month - 1
    ];
    List<int> weeks = [
      for (int i = 6; i >= 0; i--)
        DateTime.now().subtract(Duration(days: i)).weekday - 1
    ];
    List<String> monthLabels =
        months.map((value) => monthToString(value + 1)).toList();
    return _isLoading
        ? const LoadingCircle()
        : Scaffold(
            appBar: AppBar(
              title: FittedText(
                  text: "E M M I S S I O N S",
                  style: Theme.of(context).textTheme.headlineLarge),
              centerTitle: true,
              bottom: TabBar(
                tabs: myTabs,
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                dividerColor: Colors.transparent,
              ),
            ),
            body: TabBarView(controller: _tabController, children: [
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TitledBarGraph(
                      title: "Miles driven",
                      values: reorderIndices(
                          weeks,
                          listeningProvider.miles
                              .getWeekly()
                              .map((value) => units.convertFromMetric(
                                  units.unitType.length, value))
                              .toList()),
                      height: 200,
                      labels: [
                        for (int i = 6; i >= 0; i--)
                          weekdayToString(DateTime.now()
                              .subtract(Duration(days: i))
                              .weekday)
                      ]),
                  const SizedBox(
                    height: 20,
                  ),
                  TitledBarGraph(
                      title: "Distance travelled by category",
                      height: 200,
                      values: listeningProvider.miles
                          .getWeeklyDistr()
                          .values
                          .map((value) => units.convertFromMetric(
                              units.unitType.length, value))
                          .toList(),
                      labels: const ["Car", "Bike", "Walk", "Metro", "Plane"]),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyButton(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TestPage()));
                        },
                        text: "Click to edit data",
                        roundEdges: 20),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TitledBarGraph(
                      title: "Miles driven",
                      height: 200,
                      values: reorderIndices(
                          months,
                          listeningProvider.miles
                              .getYearly()
                              .map((value) => units.convertFromMetric(
                                  units.unitType.length, value))
                              .toList()),
                      labels: monthLabels),
                  const SizedBox(
                    height: 20,
                  ),
                  TitledBarGraph(
                      title: "Distance travelled by category",
                      height: 200,
                      values: listeningProvider.miles
                          .getYearlyDistr()
                          .values
                          .map((value) => units.convertFromMetric(
                              units.unitType.length, value))
                          .toList(),
                      labels: const ["Car", "Bike", "Walk", "Metro", "Plane"]),
                  const SizedBox(
                    height: 20,
                  ),
                  TitledBarGraph(
                      title: "Energy used",
                      height: 200,
                      values: reorderIndices(
                          months, listeningProvider.energy.eMonthRate),
                      labels: monthLabels),
                  const SizedBox(
                    height: 20,
                  ),
                  TitledBarGraph(
                      title: "Natural gas used",
                      height: 200,
                      values: reorderIndices(
                              months, listeningProvider.energy.gasMonthRate)
                          .map((value) => units.convertFromMetric(
                              units.unitType.volume, value))
                          .toList(),
                      labels: monthLabels),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TestPage()));
                        },
                        text: "Click to edit data",
                        roundEdges: 20),
                  ),
                ],
              ),
            ]),
          );
  }

  List<double> reorderIndices(List<int> indicies, List<double> rates) {
    List<double> output = List<double>.filled(indicies.length, 0.0);
    for (int i = 0; i < indicies.length; i++) {
      output[i] = rates[indicies[i]];
    }
    return output;
  }

  String weekdayToString(int day) {
    switch (day) {
      case 1:
        return "M";
      case 2:
        return "T";
      case 3:
        return "W";
      case 4:
        return "T";
      case 5:
        return "F";
      case 6:
        return "S";
      case 7:
        return "S";
      default:
        throw ArgumentError("Invalid day");
    }
  }

  String monthToString(int month) {
    switch (month) {
      case 1:
        return "J";
      case 2:
        return "F";
      case 3:
        return "M";
      case 4:
        return "A";
      case 5:
        return "M";
      case 6:
        return "J";
      case 7:
        return "J";
      case 8:
        return "A";
      case 9:
        return "S";
      case 10:
        return "O";
      case 11:
        return "N";
      case 12:
        return "D";
      default:
        throw ArgumentError("Invalid month");
    }
  }
}
