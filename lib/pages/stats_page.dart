import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/pages/test_page.dart';
import 'package:tracker_app/stats/emission_circle.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/stats/slideable.dart';
import 'package:tracker_app/stats/statistic_bar.dart';
import 'package:tracker_app/themes.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatefulWidget> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    await databaseProvider.loadData(uid);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    Widget loading = Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircularProgressIndicator(),
      const SizedBox(
        height: 10,
      ),
      Text("Loading...", style: Theme.of(context).textTheme.displayMedium),
    ]));

    return Scaffold(
      appBar: AppBar(
          title: FittedText(text: "M Y   S T A T S",
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true),
      body: _isLoading
          ? loading
          : ListView(padding: const EdgeInsets.all(0), children: [
              const SizedBox(height: 25),
              Center(
                child: Slideable(
                  options: EmissionCircleUtils.fromList(
                      [
                        listeningProvider.carbon
                            .computeEmissionsForDays(listeningProvider.miles, listeningProvider.energy, 7),
                        listeningProvider.carbon
                            .computeEmissionsForDays(listeningProvider.miles, listeningProvider.energy, 31),
                        listeningProvider.carbon
                            .computeEmissionsForDays(listeningProvider.miles, listeningProvider.energy, 365),
                      ],
                      listeningProvider.carbon.goal,
                      ["This week", "This month", "This year"]),
                  height: 490,
                  arrows: true,
                ),
              ),
               Padding(
                    padding: const EdgeInsets.all(10),
                    child: MyButton(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TestPage()));
                      },
                      text: "Click to finish setup",
                      roundEdges: 20
                    ),
                  ),
              Slideable(
                options: StatsUtils.fromList(
                    "Distance driven",
                    ["This Week", "This Month", "This Year"],
                    listeningProvider.miles.getAllCarStats(),
                    Provider.of<UnitsProvider>(context, listen: false)
                        .unitType
                        .length,
                    Icon(Icons.directions_car,
                        color: provider.iconColors.colorScheme.primary)),
                dots: true,
                dotsColor: provider.iconColors.colorScheme.primary,
                height: 150,
              ),
              StatisticBar(
                  taskName: "Energy",
                  value: listeningProvider.energy.electricRate,
                  timeUnit: "This month",
                  unit: Provider.of<UnitsProvider>(context, listen: false)
                      .unitType
                      .power,
                  icon: Icon(
                    Icons.bolt,
                    color: provider.iconColors.colorScheme.secondary,
                )),
            ]),
    );
  }
}
