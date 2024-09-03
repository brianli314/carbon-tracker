import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/loading_circle.dart';
import 'package:tracker_app/services/collections.dart';
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
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  DateTime today = DateTime.now();
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
    final units = Provider.of<UnitsProvider>(context, listen: false);
    return _isLoading
        ? const LoadingCircle()
        : Scaffold(
            appBar: AppBar(
                title: FittedText(
                    text: "M Y   S T A T S",
                    style: Theme.of(context).textTheme.headlineLarge),
                centerTitle: true),
            body: ListView(padding: const EdgeInsets.all(0), children: [
              const SizedBox(height: 25),
              Center(
                child: Slideable(
                  options: EmissionCircleUtils.fromList(
                      [
                        Carbon.computeEmissionsForDays(
                            listeningProvider.miles,
                            listeningProvider.energy,
                            7),
                        Carbon.computeEmissionsForDays(
                            listeningProvider.miles,
                            listeningProvider.energy,
                            31),
                        Carbon.computeEmissionsForDays(
                            listeningProvider.miles,
                            listeningProvider.energy,
                            365),
                      ],
                      listeningProvider.carbon.goal,
                      ["Past week", "Past month", "Past year"]),
                  height: 490,
                  arrows: true,
                ),
              ),
              Slideable(
                options: StatsUtils.fromList(
                    "Distance driven",
                    ["Past Week", "Past Month", "Past Year"],
                    listeningProvider.miles
                        .getAllCarStats()
                        .map((value) => units.convertFromMetric(
                            units.unitType.length, value))
                        .toList(),
                    units.unitType.length,
                    Icon(Icons.directions_car,
                        color: provider.iconColors.colorScheme.primary)),
                dots: true,
                dotsColor: provider.iconColors.colorScheme.primary,
                height: 150,
              ),
              StatisticBar(
                  taskName: "Energy",
                  value: listeningProvider.energy.eMonthRate[today.month - 1],
                  timeUnit: "This month",
                  unit: units.unitType.power,
                  icon: Icon(
                    Icons.bolt,
                    color: provider.iconColors.colorScheme.secondary,
                  )),
              StatisticBar(
                  taskName: "Natural gas",
                  value: units.convertFromMetric(units.unitType.volume,
                      listeningProvider.energy.gasMonthRate[today.month - 1]),
                  timeUnit: "This month",
                  unit: units.unitType.volume,
                  icon: Icon(Icons.water_drop,
                      color: Theme.of(context).colorScheme.inverseSurface))
            ]),
          );
  }
}
