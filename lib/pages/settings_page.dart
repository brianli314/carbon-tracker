import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/drop_down.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/space_scroll.dart';
import 'package:tracker_app/services/firestore.dart';
import 'package:tracker_app/themes.dart';
import 'package:tracker_app/units.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  bool showLogout;
  SettingsPage({
    super.key,
    this.showLogout = true,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> deleteAccount() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Delete account?",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: Text("Are you sure you want to delete this account?",
                  style: Theme.of(context).textTheme.displaySmall),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: Theme.of(context).textTheme.displaySmall)),
                TextButton(
                    onPressed: () async {
                      print(currentUser!.uid);
                      await FirestoreDatabase().deleteUserInfo(currentUser!.uid);
                      await deleteUserAccount();
                    },
                    child: Text("Delete",
                        style: Theme.of(context).textTheme.displaySmall))
              ],
            ));
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Unable to delete account",
                    style: Theme.of(context).textTheme.displayMedium),
                content: Text(
                  e.message!,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok",
                          style: Theme.of(context).textTheme.displaySmall))
                ],
              ));
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }
  
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
          footer: widget.showLogout ? Column(
            children: [
              MyButton(
                text: "Logout",
                onTap: logout,
                background: Theme.of(context).colorScheme.primaryContainer,
                textColor: Provider.of<ThemeProvider>(context)
                    .rangeColors
                    .colorScheme
                    .primary,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                text: "Delete account",
                onTap: deleteAccount,
                background: Provider.of<ThemeProvider>(context)
                    .rangeColors
                    .colorScheme
                    .primary,
                textColor: Theme.of(context).colorScheme.surface,
              ),
            ],
          ) : const SizedBox(),
          child: Column(
            children: [
              ListTile(
                leading: FittedText(
                    text: "Dark Mode",
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
                  leading: FittedText(
                      text: "Units",
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
                            value: UnitType.imperial, label: "Miles"),
                        DropdownMenuEntry(
                            value: UnitType.metric, label: "Kilometers"),
                      ])),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
