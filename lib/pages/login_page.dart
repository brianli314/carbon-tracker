import 'package:tracker_app/components/buttons.dart';
import 'package:tracker_app/components/fitted_text.dart';
import 'package:tracker_app/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_app/pages/forgot_password.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool passError = false;
  String passMsg = "";
  bool emailError = false;
  String emailMsg = "";

  @override
  void dispose(){
    super.dispose();
    if (context.mounted){
      Navigator.pop(context);
    }
  }
  void login() async {
    //Reset error msgs
    setState(() {
      passError = false;
      emailError = false;
    });

    //Loading screen
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator())
    );

    if (emailController.text.isEmpty){
      setErrorMsg(email: true, emailMsg: "Must fill in email");

    } else if (passwordController.text.isEmpty){
      setErrorMsg(pass: true, passMsg: "Must fill in password");

    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim());
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        if (e.code == "invalid-credential" || e.code == "INVALID_LOGIN_CREDENTIALS"){
          setErrorMsg(email: true, emailMsg: "Invalid credentials");

        } else {
          setErrorMsg(email: true, emailMsg: e.message ?? "Invalid input");
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
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Center(
                  child: FittedText(
                    text: "SIGN IN",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height:50),
                MyTextField(
                  hintText: "Email", 
                  hideText: false, 
                  controller: emailController,
                  error: emailError,
                  errorMsg: emailMsg,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Password", 
                  hideText: true, 
                  controller: passwordController,
                  error: passError,
                  errorMsg: passMsg,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
                  },
                    child: FittedText(
                        text: "Forgot password?",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                  )
                ),
                const SizedBox(height: 25),
                MyButton(text: "Login", onTap: login),
                const SizedBox(height: 25),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedText(
                        text: "Don't have an account?",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(width: 10),
                      FittedBox(
                        child: GestureDetector(
                          onTap: widget.onTap,
                          child: FittedText(
                            text: "Register Here",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ]
            ),
          ),
        )
      )
    );
  }
}