import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/constants.dart';
import 'package:personal_finance_tracker/responsive.dart';

import '../../components/background.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Responsive(
        mobile: MobileLoginScreen(),
        desktop: DesktopLoginScreen(),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the screen resizes when keyboard is open
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjust for keyboard
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoginScreenTopImage(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: LoginForm(),
                      ),
                      SizedBox(height: defaultPadding / 2),
                      // Additional widgets can be added here
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: LoginScreenTopImage(),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LoginForm(),
                    SizedBox(height: defaultPadding / 2),
                    // Additional widgets can be added here
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
