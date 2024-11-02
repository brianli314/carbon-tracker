import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  Future<void> resetPassword() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    setState(() {
      error = false;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Sent!", style: Theme.of(context).textTheme.displayMedium),
            content: Text("Check your inbox", style: Theme.of(context).textTheme.displaySmall),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("Ok", style: Theme.of(context).textTheme.displaySmall)
              )
            ],
          )
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = true;
        errorMsg = e.message!;
      });
      Navigator.pop(context);
    }
  }

  bool error = false;
  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25),
          children: [
            Center(
                child: FittedText(text: "Forgot Password?",
                    style: Theme.of(context).textTheme.displayLarge)),
            const SizedBox(
              height: 40,
            ),
            MyTextField(
                hideText: false,
                hintText: "Enter email",
                error: error,
                errorMsg: errorMsg,
                controller: emailController),
            const SizedBox(
              height: 40,
            ),
            MyButton(text: "Send", onTap: () => resetPassword())
          ],
        ),
      ),
    );
  }
}
