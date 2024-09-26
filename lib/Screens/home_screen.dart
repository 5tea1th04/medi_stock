import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';


class HomeScreen extends StatefulWidget {
  static String id = "home_screen";

  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int num = nameNavigation.indexOf(HomeScreen.id);

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String? userName;
  String? pharmacyName;
  String? location;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    DataSnapshot snapshot = await _databaseReference.child('users/12345').get(); // Replace '12345' with the actual user ID
    if (snapshot.exists) {
      Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        userName = userData['name'];
        pharmacyName = userData['pharmacyName'];
        location = userData['location'];
      });
    }
  }

  void saveUserData(String name, String pharmacy, String loc) {
    _databaseReference.child('users/12345').set({
      'name': name,
      'pharmacyName': pharmacy,
      'location': loc,
    });
    setState(() {
      userName = name;
      pharmacyName = pharmacy;
      location = loc;
    });
  }

  void showUserDetailsDialog() {
    final nameController = TextEditingController();
    final pharmacyController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Your Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: pharmacyController,
                decoration: InputDecoration(labelText: 'Pharmacy Name'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                saveUserData(nameController.text, pharmacyController.text, locationController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Screen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/WhatsApp Image 2024-09-26 at 13.27.57.jpeg",  // Corrected the path
                  height: 200,
                ),
                Text('MediStock', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                SizedBox(height: 60),

                userName != null
                    ? Text('Welcome, $userName!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                    : ElevatedButton(
                  onPressed: showUserDetailsDialog,
                  child: Text('Enter your details'),
                ),
                SizedBox(height: 8),
                pharmacyName != null
                    ? Text('Pharmacy Name: $pharmacyName', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                    : Container(),
                location != null
                    ? Text('Location: $location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                    : Container(),
                const SizedBox(height: 20),
                const Text(
                  'MediStock is a simple, easy-to-use web app that helps pharmacy owners and suppliers manage their supplies better. '
                      'With real-time stock tracking and automatic order updates, it ensures stock replenishment, minimizes shortages, '
                      'and reduces overstock. MediStock makes it easier for pharmacy owners to keep their shelves full, save time, and '
                      'work more smoothly with their suppliers—all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16,fontStyle:FontStyle.italic,),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PersistentBottomNavBar(
        selectedIndex: num,
        onItemTapped: (int value) {
          Navigator.popAndPushNamed(context, nameNavigation[value]);
        },
      ),
    );
  }
}