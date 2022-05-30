import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'login.dart';
import 'sign_up.dart';
import 'season_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyAnimeApp());
}

class MyAnimeApp extends StatefulWidget {
  @override
  _MyAnimeAppState createState() => _MyAnimeAppState();
}

class _MyAnimeAppState extends State {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(
                home: Center(child: Text("Something went wrong.")));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              home: (_user != null) ? Home() : Login(),
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Color(0xff252525),
                accentColor: Color(0xff7d2ae8),
              ),
              routes: {
                Home.routeName: (context) => const Home(),
                Login.routeName: (context) => const Login(),
                SignUp.routeName: (context) => const SignUp(),
                SeasonScreen.routeName: (context) => const SeasonScreen()
              },
            );
          }

          return MaterialApp(home: Center(child: Text("Loading")));
        });
  }
}
