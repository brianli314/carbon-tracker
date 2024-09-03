import 'dart:math';

import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/loading_circle.dart';
import 'package:tracker_app/components/number_question.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/components/text_field.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  DateTime today = DateTime.now();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController? monthlyElectricController;
  TextEditingController? monthlyGasController;
  TextEditingController? goalController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    await databaseProvider.loadData(uid);
    today = DateTime.now();
    setState(() => _isLoading = false);
  }

  void loadControllers(bool isMetric, UnitsProvider units) {
    monthlyElectricController = TextEditingController(
        text: listeningProvider.energy.eMonthRate[today.month - 1].toString());
    monthlyGasController = TextEditingController(
        text: units
            .convertFromMetric(units.unitType.volume,
                listeningProvider.energy.gasMonthRate[today.month - 1])
            .toString());
    goalController =
        TextEditingController(text: listeningProvider.carbon.goal.toString());
  }

  bool electricInputError = false;
  bool gasInputError = false;
  bool goalInputError = false;

  void enterDataAndNextPage() async {
    double? electric = double.tryParse(monthlyElectricController!.text);
    double? gas = double.tryParse(monthlyGasController!.text);
    double? goal = double.tryParse(goalController!.text);
    final units = Provider.of<UnitsProvider>(context, listen: false);

    setState(() {
      electricInputError = false;
      gasInputError = false;
      goalInputError = false;
    });

    if (electric == null || electric < 0) {
      setState(() {
        electricInputError = true;
      });
    } else if (gas == null || gas < 0) {
      setState(() {
        gasInputError = true;
      });
    } else if (goal == null || goal < 0) {
      setState(() {
        goalInputError = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      await databaseProvider.updateEnergyRate(uid, electric);
      await databaseProvider.updateGasRate(
          uid, units.convertToMetric(units.unitType.volume, gas));
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    loadControllers(units.isMetric, units);
    return _isLoading
        ? const LoadingCircle()
        : Scaffold(
            appBar: AppBar(
              title: FittedText(
                  text: "Edit values",
                  style: Theme.of(context).textTheme.headlineLarge),
              centerTitle: true,
            ),
            body: SpaceBetweenScrollView(
              padding: const EdgeInsets.all(15),
              footer: MyButton(text: "Complete", onTap: enterDataAndNextPage),
              child: Column(children: [
                NumberQuestion(
                  controller: monthlyElectricController!,
                  title: "Electricity use this month",
                  trailing: "kWh",
                  error: electricInputError,
                ),
                const SizedBox(height: 30),
                NumberQuestion(
                  controller: monthlyGasController!,
                  title: "Natural gas use this month",
                  trailing: units.unitType.volume,
                  error: gasInputError,
                ),
                const SizedBox(height: 30),
                NumberQuestion(
                  controller: goalController!,
                  title: "Goal: Reduce emissions by",
                  trailing: "%",
                  error: goalInputError,
                ),
                const SizedBox(height: 30)
              ]),
            ));
  }
}
