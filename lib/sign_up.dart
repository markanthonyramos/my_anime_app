import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  static const routeName = '/sign-up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                          labelText: "First Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                        },
                        controller: _firstNameController,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Last Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                            },
                            controller: _lastNameController,
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: TextFormField(
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
                          )),
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
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                            child: Text("Already have an account?"),
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
                                            .createUserWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text);

                                    if (userCredential.user != null) {
                                      _firstNameController.clear();
                                      _lastNameController.clear();
                                      _emailController.clear();
                                      _passwordController.clear();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "The account for ${userCredential.user!.email} was created successfully.")));
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "The password provided is weak.")));
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "The email is already used by another account.")));
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Text('Sign Up'))
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
