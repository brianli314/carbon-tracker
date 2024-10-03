import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/drop_down.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/loading_circle.dart';
import 'package:tracker_app/components/number_question.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/themes.dart';
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
  TextEditingController? valueController;

  String carType = "Gas";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    await databaseProvider.loadData(uid);
    today = DateTime.now();
    carType = databaseProvider.miles.carType;
    setState(() => _isLoading = false);
  }

  bool electricInputError = false;
  bool gasInputError = false;
  bool goalInputError = false;
  bool valueInputError = false;

  DateTime date = DateTime.now();
  DateFormat format = DateFormat.yMMMMd();
  String type = "Car";

  void enterDataAndNextPage() async {
    double? electric = double.tryParse(monthlyElectricController!.text);
    double? gas = double.tryParse(monthlyGasController!.text);
    double? goal = double.tryParse(goalController!.text);
    double? value = double.tryParse(valueController!.text);
    final units = Provider.of<UnitsProvider>(context, listen: false);

    setState(() {
      electricInputError = false;
      gasInputError = false;
      goalInputError = false;
      valueInputError = false;
    });

    if (electric == null || electric < 0 || electric > 100000) {
      setState(() {
        electricInputError = true;
      });
    } else if (gas == null || gas < 0|| electric > 100000) {
      setState(() {
        gasInputError = true;
      });
    } else if (goal == null || goal < 0 || goal > 100) {
      setState(() {
        goalInputError = true;
      });
    } else if (value == null || value < 0){
      setState(() {
        valueInputError = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      await databaseProvider.updateEnergyRate(uid, electric);
      await databaseProvider.updateGasRate(
          uid, units.convertToMetric(units.unitType.volume, gas));
      await databaseProvider.setCarType(uid, carType);
      await databaseProvider.setMileageFromDate(date, type, value, uid);
      await databaseProvider.setGoal(uid, goal);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  

  void loadControllers() {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    monthlyElectricController = TextEditingController(
        text: listeningProvider.energy.eMonthRate[today.month - 1].toString());
    monthlyGasController = TextEditingController(
        text: units
            .convertFromMetric(units.unitType.volume,
                listeningProvider.energy.gasMonthRate[today.month - 1])
            .toString());
    goalController =
        TextEditingController(text: listeningProvider.carbon.goal.toString());
    valueController = TextEditingController(
        text: units.roundDouble(listeningProvider.getMileageFromDate(date, type), 2).toString());
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    if (monthlyGasController == null || monthlyElectricController == null || goalController == null || valueController == null){
      loadControllers();
    }
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
              padding: const EdgeInsets.all(25),
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
                FittedText(
                    text: "Initial emissions (from setup):",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(
                  height: 20,
                ),
                FittedText(
                  text:
                      "${units.roundDouble(listeningProvider.carbon.average * 24 * 31, 2)} ${units.unitType.weight} / month",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                NumberQuestion(
                  controller: goalController!,
                  title: "Change goal",
                  trailing: "%",
                  error: goalInputError,
                ),
                const SizedBox(height: 30),
                Center(
                    child: FittedText(
                  text: "Car Type",
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
                const SizedBox(
                  height: 30,
                ),
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
                const SizedBox(height: 30),
                NumberQuestion(
                  title: "Edit mileage",
                  controller: valueController!,
                  error: valueInputError,
                  trailing: units.unitType.length,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MyDropDownMenu(
                      options: const [
                        DropdownMenuEntry(value: "Car", label: "Car"),
                        DropdownMenuEntry(value: "Bike", label: "Bike"),
                        DropdownMenuEntry(value: "Walk", label: "Walk"),
                        DropdownMenuEntry(value: "Plane", label: "Plane"),
                      ],
                      initialSelection: type,
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                        loadControllers();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoButton(
                        child: FittedText(
                          text: format.format(date),
                          style: Theme.of(context).textTheme.headlineSmall!
                          .apply(color: Provider.of<ThemeProvider>(context, listen: false).iconColors.colorScheme.secondary),
                        ),
                        onPressed: () => _showDialog(
                              CupertinoDatePicker(
                                initialDateTime: date,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                showDayOfWeek: true,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => date = newDate);
                                  loadControllers();
                                },
                              ),
                            )),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ]),
            ));
  }
}
