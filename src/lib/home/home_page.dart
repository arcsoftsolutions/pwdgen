import 'package:flutter/material.dart';

import '../generate/generate_page.dart';
import '../history/history_page.dart';
import '../shared/bottom_navigation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _pageIndex = 0;

  final List<BottomNavigationPage> _pages = <BottomNavigationPage>[
    const GeneratePage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationPage activePage = _pages[_pageIndex];
    final String activePageTitle = activePage.getTitle(context).toUpperCase();
    final Widget activePageWidget = activePage as Widget;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          activePageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: activePageWidget,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _getDestinations(),
      ),
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  List<NavigationDestination> _getDestinations() {
    return _pages.map(_buildDestination).toList();
  }

  NavigationDestination _buildDestination(BottomNavigationPage page) =>
      NavigationDestination(
        icon: page.getIcon(),
        label: page.getTitle(context),
      );
}
