import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/drop_down.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/components/text_field.dart';
import 'package:tracker_app/services/database_provider.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  String uid = FirebaseAuth.instance.currentUser!.uid;

  static const electricAverage = 899;
  static const gasAverage = 196;
  static const gasAverageMeters = 5.55;

  TextEditingController monthlyElectricController = TextEditingController();
  TextEditingController monthlyGasController = TextEditingController();

  bool electricInputError = false;
  String electricMsg = "";
  bool gasInputError = false;
  String gasMsg = "";

  bool useMetric = false;

  void enterDataAndNextPage() async {
    int? electric;
    int? gas;

    if (monthlyElectricController.text.isEmpty){
      electric = electricAverage;
    } else {
      electric = int.tryParse(monthlyElectricController.text);
    }
    
    if(monthlyGasController.text.isEmpty){
      gas = gasAverage;
    } else {
      gas = int.tryParse(monthlyGasController.text);
    }
    
    if (electric == null){
      setState(() {
        electricInputError = true;
        electricMsg = "Invalid input";
      });
    } else if (gas == null){
      setState(() {
        gasInputError = true;
        gasMsg = "Invalid input";
      });
    } else {
      showDialog(
        context: context, 
        builder: (context) => const Center(child: CircularProgressIndicator())
      );
      await databaseProvider.updateEnergyRate(uid, electric);
      Navigator.pop(context);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    UnitsProvider units = Provider.of<UnitsProvider>(context, listen: false);
    num currentAvg = useMetric ? gasAverageMeters : gasAverage;
    return Scaffold(
        appBar: AppBar(
          title: Text("Complete Setup",
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
        ),
        body: SpaceBetweenScrollView(
          padding: const EdgeInsets.all(25),
          footer: MyButton(text: "Next", onTap: enterDataAndNextPage),
            
          child: Column(
          children: [
            Center(
                child: Text("Average monthly electricity use",
                    style: Theme.of(context).textTheme.headlineMedium)),
            const SizedBox(height: 40),
            ListTile(
                leading: SizedBox(
                    width: MediaQuery.sizeOf(context).width - 210,
                    child: MyNumberField(
                        hintText: electricAverage.toString(),
                        controller: monthlyElectricController,
                        error: electricInputError,
                        errorMsg: electricMsg,
                      )),
                trailing: const Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Text("kWh"),
                )),
            const SizedBox(height: 30),
            Center(
                child: Text("Average monthly natural gas use",
                    style: Theme.of(context).textTheme.headlineMedium)),
            const SizedBox(height: 20),
            ListTile(
                leading: MyNumberField(
                    hintText: currentAvg.toString(),
                    controller: monthlyGasController,
                    width: MediaQuery.sizeOf(context).width - 210,
                    error: gasInputError,
                    errorMsg: gasMsg,
                  ),
                trailing: SizedBox(
                  width: 82,
                  child: MyDropDownMenu(
                    options: [
                      DropdownMenuEntry(
                          value: "Cubic ft",
                          label: "ft³",
                          labelWidget: Text("Cubic feet",
                              style: Theme.of(context).textTheme.displaySmall)),
                      DropdownMenuEntry(
                          value: "Cubic meters",
                          label: "m³",
                          labelWidget: Text("Cubic meters",
                              style: Theme.of(context).textTheme.displaySmall))
                    ],
                    initialSelection: units.unitType.volume,
                    onChanged: (value) {
                      setState(() {
                        if (value == "Cubic ft") {
                          useMetric = false;
                        } else {
                          useMetric = true;
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30)
          ]),
        ));
  }
}
