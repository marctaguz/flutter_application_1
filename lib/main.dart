import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_home.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/manage_university.dart';
import 'package:flutter_application_1/manage_user.dart';
import 'package:flutter_application_1/manage_vendor.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(237, 235, 222, 1),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
             // Change this to desired back arrow color
          ),
          // If using a leading button, you might also want to specify here
          //backButtonTheme: BackButtonThemeData(color: Colors.red),
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 2;
  static final List<Widget> _widgetOptions = <Widget>[
    ManageUniversityPage(),
    ManageVendorPage(),
    DashboardScreen(),
    ManageUserPage(),
    DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'University',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Vendor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Color.fromRGBO(28, 68, 64, 1),
        selectedItemColor: Color.fromRGBO(237,235,222,1),
        unselectedItemColor: const Color.fromARGB(151, 189, 189, 189),
        onTap: _onItemTapped,
      ),
    );
  }
}
