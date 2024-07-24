import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load/main.dart';
import 'package:load/profile.dart';
import 'package:intl/intl.dart';
class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
}

void signOutUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyHomePage()));
  } catch (e) {
    print('Error signing out: $e');
  }
}

class _MyButtonState extends State<MyButton> {
  DatabaseReference _database = FirebaseDatabase.instance.reference();
  String _data = '';
  var Quantity;
  late UserData _userData = UserData(name: 'Name', email: 'Email');
  
var d;
  bool _isLoading = false;
  
  bool _showReorderedText = false; 

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.reference();
    _fetchUserData();
    _listenToDataChanges();
 



  }

void _fetchUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData = userDataSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _userData = UserData(name: userData['name'], email: userData['email']);
        });
      } else {
        print('User data not found for user ${user.uid}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  } else {
    print('User not authenticated');
  }
}


  void _listenToDataChanges() {
    DatabaseReference ref = _database.child("sensors/Load/value");
    ref.onValue.listen((event) {
      setState(() {
        _data = event.snapshot.value.toString();
        d=int.tryParse(event.snapshot.value.toString());
        Quantity = int.tryParse(_data);
        if (Quantity != null) {
          Quantity = (Quantity*1000) ~/ 30; 
          print(Quantity);
        }
        _isLoading = false;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _data = 'Error: $error';
        print(_data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
         DateTime now = DateTime.now();
DateTime nextDay = now.add(Duration(days: 2));
  var formattedNow = DateFormat('yyyy-MM-dd').format(now);
var formattedNextDay = DateFormat('yyyy-MM-dd').format(nextDay);

    return Scaffold(
      backgroundColor: Color(0xFF6A6FDE),
      appBar: AppBar(
        title: Text(
          'Smart Bin System',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black),
            fontSize: 24,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)), color: Colors.white,),
                width: double.infinity,
                height: 550,
                child:
                 Column(
                   children: [
                     Center(
                      child: Image.asset(
                        'assets/images/Designer.png',
                        fit: BoxFit.cover,
                      ),
                                 ),
                           ElevatedButton(
            onPressed: () {
              print("button pressed");
              setState(() {
          _showReorderedText =  d != null && d < 5;
            print("_showReorderedText (onPressed): $_showReorderedText");
            print("Quantity (onPressed): $Quantity");
          
              });
            },
            child: Text(
              'Reorder Status',
              style: GoogleFonts.poppins(
          textStyle: TextStyle(color: Colors.black),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
              ),
            ),
          ),
          
            SizedBox(height: 10),
            Visibility(
              visible: _showReorderedText,
              child: Text(
                'Reordered',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
              Visibility(
              visible: _showReorderedText,
              child: Text(
                'Refill Date:$formattedNextDay',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.black),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
                   ],
                 ),
              ),
              
              SizedBox(height: 20),
          
              Container(
                width: double.infinity,
                height: 200,
                color: Color(0xFF6A6FDE),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white),
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width / 2.5 - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  color: Colors.white.withOpacity(0.3),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '$_data',
                                            style: TextStyle(fontSize: 32),
                                          ),
                                          TextSpan(
                                            text: '\n',
                                          ),
                                          TextSpan(
                                            text: 'Kg',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(color: Colors.white),
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width / 2.5 - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  color: Colors.white.withOpacity(0.3),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '$Quantity',
                                            style: TextStyle(fontSize: 32),
                                          ),
                                          TextSpan(
                                            text: '\n',
                                          ),
                                          TextSpan(
                                            text: 'Pieces',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6A6FDE),
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF6A6FDE)),
                accountName: Text(
                  _userData != null ? _userData.name : 'Name',
                  style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
                ),
      
                accountEmail: Text(_userData != null ? _userData.email : 'Email',style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    _userData != null ? _userData.name.substring(0, 1) : 'A',
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(' My Profile ',style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),),
              onTap: () {
            Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => ProfilePage()),
);

              },
            ),
          
            ListTile(
              leading: const Icon(Icons.edit),
              title:  Text(' Edit Profile ',style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title:  Text('LogOut',style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.black),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),),
              onTap: () {
                signOutUser(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    _listenToDataChanges();
  }
}

class UserData {
  final String name;
  final String email;

  UserData({required this.name, required this.email});
}
