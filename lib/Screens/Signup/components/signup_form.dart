import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/Screens/Home/home_page_screen.dart';
import 'package:personal_finance_tracker/model/user.dart';
import 'package:personal_finance_tracker/services/auth_service.dart';
import 'package:personal_finance_tracker/services/google/google_service.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  ValueNotifier userCredential = ValueNotifier('');

  Uint8List? _imageData;

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    var result = await AuthService.signUpWithEmailAndPassword(
      emailAddress: email,
      password: password,
      imageData: _imageData,
      firstName: firstName,
      lastName: lastName,
    );

    if (result is User) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _firstNameController,
                textInputAction: TextInputAction.done,
                obscureText: false,
                cursorColor: kPrimaryColor,
                onSaved: (userName) {},
                decoration: const InputDecoration(
                  hintText: "Your Name",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.strikethrough_s_outlined),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _lastNameController,
                textInputAction: TextInputAction.done,
                obscureText: false,
                onSaved: (userLastName) {},
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "Your Last Name",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.ac_unit_sharp),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
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
                              'sign up with Google+',
                              style: new TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            icon: new Image.asset("assets/google_plus.png",
                                width: 24.0, height: 24.0),
                            onPressed: () async {
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => GoogleSignInScreen(),
                              //   ),
                              // );

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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                                //TODO: Burada yönlendirme işlemin yapacaksın ana sayfaya
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
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            ElevatedButton(
              onPressed: () async {
                print(_emailController.text);
                print(_passwordController.text);
                print(_firstNameController.text);
                print(_lastNameController.text);
                _register();
              },
              child: Text("Sign Up".toUpperCase()),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
