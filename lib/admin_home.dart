import 'package:flutter/material.dart';
import 'package:flutter_application_1/manage_university.dart';
import 'package:flutter_application_1/manage_user.dart';
import 'package:flutter_application_1/manage_vendor.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 235, 222, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(237, 235, 222, 1),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Assuming you have an image asset for the logo
            Image.asset(
              'assets/images/logo.jpg', // Replace with your asset image path
              fit: BoxFit.cover,
              height: 30, // Set the size of the logo as needed
            ),
            SizedBox(width: 8), // Provide some spacing between the logo and the title 
            const Text('UniMeals',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromRGBO(28,68,64,1),
            ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color.fromRGBO(28,68,64,1)
                          ),
                        ),
                        Text(
                          '25 Dec 2024',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                margin: EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(243, 241, 234, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)), //rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13.0),
                      child: Text(
                        'Quick Access',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0, // Horizontal space between cards
                      runSpacing: 8.0, // Vertical space between lines
                      children: [
                        MetricCard(title: 'Manage Universities', icon: Icons.school, iconColor: Colors.red, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageUniversityPage())),),
                        MetricCard(title: 'Manage Vendors', icon: Icons.add_business, iconColor: Colors.red, onTap: () => {/* Navigate somewhere */},),
                        MetricCard(title: 'Manage Users', icon: Icons.people, iconColor: Colors.green, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ManageUserPage())),),
                        MetricCard(title: 'Manage Depression', icon: Icons.supervised_user_circle, iconColor: Colors.blue, onTap: () => {/* Navigate somewhere */},),
                      ],
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}

class MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const MetricCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Color.fromRGBO(28, 69, 63, 1),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: (MediaQuery.of(context).size.width / 2) - 32,
          child: Column(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
