import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/drop_down.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/loading_circle.dart';
import 'package:tracker_app/components/number_question.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/units.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final double defaultElectric = 900;
  final double defaultGas = 5.55;
  final double defaultGoal = 50;
  final double defaultMileage = 1931;
  final double defaultEmissions = 766.43;
  String carType = "Gas";

  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  TextEditingController monthlyElectricController = TextEditingController();
  TextEditingController monthlyGasController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController mileageController = TextEditingController();

  bool electricInputError = false;
  bool gasInputError = false;
  bool goalInputError = false;
  bool milesInputError = false;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool _isLoading = true;
  bool secondPage = false;

  double emissions = 0;

  @override
  void initState() {
    super.initState();
    loadSetup();
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    monthlyElectricController =
        TextEditingController(text: defaultElectric.toString());
    monthlyGasController = TextEditingController(
        text: units
            .convertFromMetric(units.unitType.volume, defaultGas)
            .toString());
    goalController = TextEditingController(text: defaultGoal.toString());
    mileageController = TextEditingController(
        text: units
            .convertFromMetric(units.unitType.length, defaultMileage)
            .toString());

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose(){
    super.dispose();
    if (context.mounted) Navigator.pop(context);
  }

  void loadSetup() async {
    await databaseProvider.loadData(uid);
  }

  void finishSetup() async {
    double? goal = double.tryParse(goalController.text);

    setState(() {
      goalInputError = false;
    });

    if (goal == null || goal < 0 || goal > 100) {
      setState(() {
        goalInputError = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      await databaseProvider.setGoal(uid, goal);
      Navigator.pop(context);
      await databaseProvider.completeSetup(uid);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  void enterDataAndNextPage() async {
    double? electric = double.tryParse(monthlyElectricController.text);
    double? gas = double.tryParse(monthlyGasController.text);
    double? mileage = double.tryParse(mileageController.text);

    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    setState(() {
      electricInputError = false;
      gasInputError = false;
      milesInputError = false;
    });

    if (electric == null || electric < 0 || electric > 100000) {
      setState(() {
        electricInputError = true;
      });
    } else if (gas == null || gas < 0 || gas > 100000) {
      setState(() {
        gasInputError = true;
      });
    } else if (mileage == null || mileage < 0) {
      setState(() {
        milesInputError = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

      await databaseProvider.fillElectric(
          uid, electric, units.convertToMetric(units.unitType.volume, gas));
      await databaseProvider.fillMileage(
          uid, units.convertToMetric(units.unitType.length, mileage));
      Navigator.pop(context);
      emissions = computeEmissions(mileage, electric, gas, carType);
      await databaseProvider.setAverage(uid, emissions / (31*24));
      await databaseProvider.setCarType(uid, carType);
      emissions = units.convertFromMetric(units.unitType.weight, emissions);
      setState(() {
        secondPage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    return secondPage
        ? buildSecondPage(context, emissions)
        : Scaffold(
            appBar: AppBar(
              title: FittedText(
                  text: "Complete setup",
                  style: Theme.of(context).textTheme.headlineLarge),
              centerTitle: true,
            ),
            body: _isLoading
                ? const LoadingCircle()
                : SpaceBetweenScrollView(
                    padding: const EdgeInsets.all(25),
                    footer:
                        MyButton(text: "Next", onTap: enterDataAndNextPage),
                    child: Column(children: [
                      NumberQuestion(
                        controller: monthlyElectricController,
                        title: "Electricity use this month",
                        trailing: "kWh",
                        error: electricInputError,
                      ),
                      const SizedBox(height: 30),
                      NumberQuestion(
                        controller: monthlyGasController,
                        title: "Natural gas use this month",
                        trailing: units.unitType.volume,
                        error: gasInputError,
                      ),
                      const SizedBox(height: 30),
                      NumberQuestion(
                        controller: mileageController,
                        title: "Monthly mileage",
                        trailing: units.unitType.length,
                        error: milesInputError,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: FittedText(text: "Car Type", 
                        style: Theme.of(context).textTheme.headlineMedium,)
                      ),
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: MyDropDownMenu(
                            options: const [
                              DropdownMenuEntry(value: "Gas", label: "Gas"),
                              DropdownMenuEntry(value: "Diesel", label: "Diesel"),
                              DropdownMenuEntry(value: "Hybrid", label: "Hybrid"),
                              DropdownMenuEntry(value: "Electric", label: "Electric"),
                            ],
                            initialSelection: carType,
                            onChanged: (value) => carType = value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30)
                    ]),
                  ));
  }

  double computeEmissions(double mileage, double electric, double gas, String gasType) {
    final units = Provider.of<UnitsProvider>(context, listen: false);
    double factor = 0;
    switch(gasType){
      case "Gas": factor = 0.170;
      case "Diesel": factor = 0.171;
      case "Hybrid": factor = 0.068;
      case "Electric": factor = 0.047;
    }
    return units.roundDouble(
            units.convertToMetric(units.unitType.length, mileage) * factor +
            electric * 0.475 +
            units.convertToMetric(units.unitType.volume, gas) * 1.92,
        2);
  }

  Widget buildSecondPage(BuildContext context, double emissions) {
    final units = Provider.of<UnitsProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: FittedText(
              text: "Complete setup",
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
        ),
        body: SpaceBetweenScrollView(
            padding: const EdgeInsets.all(25),
            footer: Column(
              children: [
                MyButton(text: "Back", onTap: () {
                  setState(() {
                    secondPage = false;
                  });
                }),
                const SizedBox(height: 30,),
                MyButton(text: "Complete", onTap: finishSetup),
              ],
            ),
            child: Column(
              children: [
                FittedText(
                    text: "Your emissions:",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 10,
                ),
                FittedText(
                  text: "$emissions ${units.unitType.weight} CO2 / month",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10,),
                FittedText(
                  text: "Average: ${units.convertFromMetric(units.unitType.weight, defaultEmissions)}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                NumberQuestion(
                  controller: goalController,
                  title: "Goal: Reduce emissions by",
                  trailing: "%",
                  error: goalInputError,
                ),
                const SizedBox(height: 30),
              ],
            )));
  }
}
