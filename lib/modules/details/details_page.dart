import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).primaryColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.mail)),
            label: 'Email',
          ),
          NavigationDestination(
            icon: Badge(label: Text('2'), child: Icon(Icons.comment)),
            label: 'Add comment',
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Current Page Index: $currentPageIndex',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
