import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/text_field.dart';
import 'package:tracker_app/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final FirestoreDatabase _db = FirestoreDatabase();

  bool passError = false;
  String passMsg = "";
  bool emailError = false;
  String emailMsg = "";
  bool userError = false;


  void dispose(){
    super.dispose();
    if (context.mounted) Navigator.pop(context);
  }
  void registerUser() async {
    //Reset error msgs
    setState(() {
      passError = false;
      emailError = false;
      userError = false;
    });
    //Loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (emailController.text.isEmpty) {
      setErrorMsg(email: true, emailMsg: "Must fill in email");

    } else if (passwordController.text.isEmpty || confirmPassController.text.isEmpty) {
      setErrorMsg(pass: true, passMsg: "Must fill in password");

    } else if (usernameController.text.isEmpty) {
      setErrorMsg(user: true);

    } else if (passwordController.text != confirmPassController.text) {
      setErrorMsg(pass: true, passMsg: "Passwords do not match");

    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text);

        if (context.mounted) Navigator.pop(context);

        _db.createUserDocument(emailController.text, usernameController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          setErrorMsg(pass: true, passMsg: e.message!);
        } else {
          setErrorMsg(email: true, emailMsg: e.message ?? "Invalid inputs");
        }
      }
    }
  }

  void setErrorMsg(
      {bool pass = false,
      String passMsg = "",
      bool email = false,
      String emailMsg = "",
      bool user = false}) {
    setState(() {
      passError = pass;
      this.passMsg = passMsg;
      emailError = email;
      this.emailMsg = emailMsg;
      userError = user;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget gap = const SizedBox(height: 10);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              FittedText(
                text: "REGISTER",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 50),
              MyTextField(
                hintText: "Username",
                hideText: false,
                controller: usernameController,
                error: userError,
                errorMsg: "Must fill in username",
              ),
              gap,
              MyTextField(
                hintText: "Email",
                hideText: false,
                controller: emailController,
                error: emailError,
                errorMsg: emailMsg,
              ),
              gap,
              MyTextField(
                  hintText: "Password",
                  hideText: true,
                  controller: passwordController,
                  error: passError,
                  errorMsg: passMsg),
              gap,
              MyTextField(
                  hintText: "Re-enter password",
                  hideText: true,
                  controller: confirmPassController,
                  error: passError,
                  errorMsg: passMsg),
              const SizedBox(height: 25),
              MyButton(text: "Register", onTap: registerUser),
              const SizedBox(height: 25),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Here",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        )));
  }
}
