import 'package:auto_size_text/auto_size_text.dart';
import 'package:tracker_app/components/drop_down.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/themes.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

void logout() {
  FirebaseAuth.instance.signOut();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UnitsProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: FittedText(
              text: "S E T T I N G S",
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
        ),
        body: SpaceBetweenScrollView(
          padding: const EdgeInsets.all(25),
          footer: GestureDetector(
              onTap: logout,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: FittedText(
                      text: "Logout",
                      style: Theme.of(context).textTheme.displayMedium!.apply(
                          color: Provider.of<ThemeProvider>(context)
                              .rangeColors
                              .colorScheme
                              .primary)),
                ),
              )),
          child: Column(
            children: [
              ListTile(
                title: Text("Dark Mode",
                    style: Theme.of(context).textTheme.headlineMedium),
                trailing: FittedBox(
                  child: CupertinoSwitch(
                      onChanged: (value) =>
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggle(),
                      activeColor: Theme.of(context).colorScheme.inversePrimary,
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode),
                ),
              ),
              const SizedBox(height: 25),
              ListTile(
                  title: Text("Units",
                      style: Theme.of(context).textTheme.headlineMedium),
                  trailing: MyDropDownMenu(
                    width: 120,
                      initialSelection: provider.unitType,
                      onChanged: (unit) {
                        setState(() {
                          provider.unitType = unit!;
                        });
                      },
                      options: const [
                        DropdownMenuEntry(
                            value: UnitType.imperial, label: "Imperial"),
                        DropdownMenuEntry(
                            value: UnitType.metric, label: "Metric"),
                      ])),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
