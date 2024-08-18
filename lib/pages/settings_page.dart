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
          title: Text("S E T T I N G S",
              style: Theme.of(context).textTheme.headlineLarge),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ListTile(
                title: Text("Dark Mode", style: Theme.of(context).textTheme.headlineMedium),
                trailing: CupertinoSwitch(
                    onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggle(),
                    activeColor: Theme.of(context).colorScheme.inversePrimary,
                    value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode),
              ),
              const SizedBox(height: 25),
              ListTile(
                  title: Text("Units", style: Theme.of(context).textTheme.headlineMedium),
                  trailing: DropdownMenu(
                      initialSelection: provider.unitType,
                      onSelected: (UnitType? unit) {
                        setState(() {
                          provider.unitType = unit!;
                        });
                      },
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: UnitType.imperial, label: "Imperial"),
                        DropdownMenuEntry(value: UnitType.metric, label: "Metric"),
                      ]
                  )
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Center(
                    child: Text("Logout",
                        style: Theme.of(context).textTheme.headlineMedium!.apply(
                          color: Provider.of<ThemeProvider>(context,listen: false).rangeColors.colorScheme.primary)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15,)
            ],
          ),
        ));
  }
}
