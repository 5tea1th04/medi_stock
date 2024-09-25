// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:medi_stock/Screens/home_screen.dart';
//
//
// class NewProfileScreen extends StatefulWidget {
//   static String id = "new_profile_screen";
//   const NewProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NewProfileScreen> createState() => _NewProfileScreenState();
// }
//
// class _NewProfileScreenState extends State<NewProfileScreen> {
//   late DatabaseReference _dbRef; // Reference to the Firebase Database
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebase(); // Initialize Firebase
//   }
//
//   Future<void> _initializeFirebase() async {
//     final FirebaseApp app = await Firebase.initializeApp(
//       name: 'myApp', // Name your Firebase app instance
//       options: FirebaseOptions(
//         apiKey: "your_api_key", // Your API key
//         appId: "your_app_id", // Your App ID
//         messagingSenderId: "your_messaging_sender_id", // Your Messaging Sender ID
//         projectId: "your_project_id", // Your Project ID
//         databaseURL: "https://medistock-74644-default-rtdb.asia-southeast1.firebasedatabase.app", // Your Database URL
//       ),
//     );
//
//     _dbRef = FirebaseDatabase.instanceFor(app: app).ref().child('users'); // Set the database reference to 'users' node
//   }
//
//   // Function to save data to Firebase
//   void _saveProfile() {
//     String name = _nameController.text;
//     String location = _locationController.text;
//
//     if (name.isNotEmpty && location.isNotEmpty) {
//       String userId = _dbRef.push().key!; // Generate a unique key for the new user
//
//       // Save the user data to Firebase Realtime Database under the 'users' node
//       _dbRef.child(userId).set({
//         'name': name,
//         'location': location,
//       }).then((_) {
//         Navigator.pushNamed(context, HomeScreen.id);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile saved successfully!')),
//
//         );
//         _nameController.clear();
//         _locationController.clear();
//       }).catchError((onError) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save profile!')),
//         );
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter both name and location')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Profile Set"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(hintText: 'Name'),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _locationController,
//               decoration: InputDecoration(hintText: 'Location'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               child: Text('Save Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
