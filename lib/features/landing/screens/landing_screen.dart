import 'package:flutter/material.dart';
import 'package:supperapp/common/widgets/custom_button.dart';
import 'package:supperapp/features/auth/screens/login_screen.dart';
import 'package:supperapp/widgets/colors/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);
  void navigatetoLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Welcome to SuperApp',
                style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              SizedBox(
                height: size.height / 9,
              ),
              Image.asset(
                'assets/2.png',
                height: 340,
                width: 340,
                // color: tabColor,
              ),
              SizedBox(
                height: size.height / 9,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read our privacy. Tap "Agree and continue" to accept the terms of services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  btntext: 'Agree and continue',
                  onPressed: () {
                    navigatetoLoginScreen(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
