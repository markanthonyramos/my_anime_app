import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'explore.dart';
import 'watchlist.dart';
import 'history.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State {
  User? _user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  List<Widget> _widgetTabs = [
    Explore(),
    Watchlist(),
    History(),
    Profile(),
  ];

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_user!.email}"),
        actions: [
          IconButton(
              onPressed: () async {
                await showSearch(
                    context: context, delegate: _HomeSearchDelegate());
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logged out successfully.")));
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: _widgetTabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _navigate,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: 'Profile')
        ],
      ),
    );
  }
}

class _HomeSearchDelegate extends SearchDelegate {
  final List<String> _data = [
    'Bleach',
    'Bunny Girl Senpai',
    'Darling in the FRANXX',
    'Dr. Stone',
    'Kaguya Sama',
    'Knockout',
    'Naruto',
    'One Piece'
  ];
  final List<String> _history = ['Bleach', 'Naruto', 'Knockout', 'One Piece'];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isEmpty)
        IconButton(onPressed: () {}, icon: Icon(Icons.mic))
      else
        IconButton(
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
            icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = query.isEmpty
        ? _history
        : _data
            .where((String element) =>
                element.startsWith(RegExp(query, caseSensitive: false)))
            .toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
            title: Text(suggestions[i]),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }
}
