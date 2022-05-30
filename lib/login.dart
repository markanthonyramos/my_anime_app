import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                FlutterLogo(
                  size: MediaQuery.of(context).size.width * 0.3,
                ),
                Spacer(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                        },
                        controller: _emailController,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                            },
                            controller: _passwordController,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "/sign-up");
                            },
                            child: Text("Don't have an account yet?"),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.only(left: 2))),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontWeight: FontWeight.bold)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).accentColor)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text);

                                    if (userCredential.user != null) {
                                      _emailController.clear();
                                      _passwordController.clear();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Logged in successfully.")));

                                      Navigator.pushReplacementNamed(
                                          context, "/home");
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'No user found for that email.')));
                                    } else if (e.code == 'wrong-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Wrong password specified.')));
                                    }
                                  }
                                }
                              },
                              child: Text('Login'))
                        ],
                      )
                    ],
                  ),
                ),
                Spacer()
              ]),
        ));
  }
}
