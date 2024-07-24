import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import for Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load/main.dart'; // Import for Firebase Auth
 // Import for Firebase
 void signOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
  } catch (e) {
    print('Error signing out: $e');
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Firebase variables and data holders
  final _firestore = FirebaseFirestore.instance; // Instance of Firestore
  String _name = '';
  String _email = '';
  String _phoneNumber = '';

  // Function to fetch data from Firebase
 Future<void> _fetchData() async {
   final _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser; // Get the current user

    if (currentUser != null) {
      // Use the current user's ID
     final _userId = currentUser.uid; // Now _userId is defined

      // Replace with the path to your user data collection
      final docRef = _firestore.collection('users').doc(_userId);

      try {
        final doc = await docRef.get();
        if (doc.exists) {
          final data = doc.data();
          setState(() {
            _name = data?['name'] ?? '';
            _email = data?['email'] ?? '';
            _phoneNumber = data?['phoneNumber'] ?? '';
          });
        } else {
          print('No document found');
        }
      } catch (error) {
        print('Error fetching data: $error');
      }
    } else {
      print('No user signed in');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize Firebase app (if not already done)
    Firebase.initializeApp().then((_) => _fetchData()); // Fetch data after init
  }

  @override
@override
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
          },
        ),
        title: Text('Profile Page'),
        backgroundColor: Color.fromRGBO(143, 148, 251, .2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(143, 148, 251, 1), Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              SizedBox(height: 16),
              Text(
                _name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: _name.isNotEmpty,
                child: Column(
                  children: [
                    InputField(label: 'Full name', initialValue: _name),
                    InputField(label: 'Email', initialValue: _email),
                    InputField(label: 'Phone number', initialValue: _phoneNumber),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Sign out logic
                      },
                      child: Text(
                        'Sign out',
                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.grey),
                  Icon(Icons.search, color: Colors.grey),
                  Icon(Icons.notifications, color: Colors.grey),
                  Icon(Icons.person, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}




 
}
class InputField extends StatefulWidget {
  final String label;
  final String initialValue;

  InputField({required this.label, required this.initialValue});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: _controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

