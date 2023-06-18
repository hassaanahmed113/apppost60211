import 'package:blogapp60211/components/round_button.dart';
import 'package:blogapp60211/screens/login_screen.dart';
import 'package:blogapp60211/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo.jpg"),
              RoundButton(
                  title: "Login",
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  }),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: "Register",
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
