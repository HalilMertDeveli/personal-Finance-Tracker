import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:personal_finance_tracker/Screens/Home/home_page_screen.dart';
import 'package:personal_finance_tracker/model/user.dart';
import 'package:personal_finance_tracker/services/auth_service.dart';
import 'package:personal_finance_tracker/services/google/google_service.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ValueNotifier userCredential = ValueNotifier('');

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    var result = await AuthService.loginWithEmailAndPassword(email, password);

    if (result is User) {
      // Giriş başarılı, ana sayfaya yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Hata durumunu göster
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    final Size screenSize = media.size;

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          new Container(
            width: screenSize.width,
            child: new Column(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 50.0,
                        width: 210.0,
                        child: new ElevatedButton.icon(
                            label: new Text(
                              'Login with Google+',
                              style: new TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            icon: new Image.asset("assets/google_plus.png",
                                width: 24.0, height: 24.0),
                            onPressed: () async {
                              userCredential.value = await signInWithGoogle();
                              if (userCredential.value != null) {
                                print(userCredential.value.user!.email);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        height: 50.0,
                        width: 210.0,
                        child: new ElevatedButton.icon(
                          label: new Text(
                            'Login with Facebook',
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: new Image.asset(
                            "assets/facebook.png",
                            width: 24.0,
                            height: 24.0,
                          ),
                          // icon: const Icon(Icons.adjust, size: 28.0,color: Colors.white),

                          onPressed: () async {
                            final LoginResult result =
                                await FacebookAuth.instance.login();
                            if (result.status == LoginStatus.success) {
                              // you are logged
                              final AccessToken accessToken =
                                  result.accessToken!;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else {
                              print(result.status);
                              print(result.message);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              print(_emailController.text);
              print(_passwordController.text);
              _login();
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
