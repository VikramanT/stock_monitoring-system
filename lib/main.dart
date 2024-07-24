import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/auth_methods.dart';
import 'package:load/homescreen.dart';
import 'package:load/loginpage.dart';
import 'package:load/signupscreen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:load/firebase_options.dart';
import 'package:palette_generator/palette_generator.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final response = await http.get(Uri.parse('https://loadiot-3f724-default-rtdb.firebaseio.com/sensors.json?auth=zvYJBP4j4ZwaJt3kdoPkKVSXAqKsPkhqjQcxwAGH'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body); // Parse JSON response

      // Check if "Load" key exists in the response data
      if (responseData.containsKey("Load")) {
        final loadData = responseData["Load"];
        if (loadData.containsKey("value")) {
          int value = int.tryParse(loadData["value"]) ?? 0;

          print('Fetched value: $value');

          if (value < 5) {
            print('Value is less than 5. Displaying notification.');
            LocalNotificationService.displayNotification(
              'Critical Load Alert',
              'M5 bolt: $value kg',
            );
          } else {
            print('Value is greater than or equal to 5. Not displaying notification.');
          }
        } else {
          print('Value key not found in Load data.');
        }
      } else {
        print('Load key not found in response data.');
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
    return Future.value(true);
  });
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   await FirebaseAppCheck.instance.activate(

    androidProvider: AndroidProvider.debug,
    
  );
  Workmanager().initialize(callbackDispatcher);
  runApp(MyApp());
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> displayNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailIdController = new TextEditingController();
final TextEditingController _passwordController = new TextEditingController();
bool _isLoading = false;
  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
    checkUserLoggedIn();
  });
 
    LocalNotificationService.initialize();
    _startBackgroundTask();
  }
void _logInUser() async {
  if (_emailIdController.text.isEmpty || _passwordController.text.isEmpty) {
    _showEmptyDialog("Email and password are required.");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  String result = await AuthMethods().logInUser(
    email: _emailIdController.text,
    password: _passwordController.text,
  );

  if (result == 'success') {
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyButton()));
    // No navigation logic here, it's handled by checkUserLoggedIn
  } else {
    // Display error message
    var snackdemo = SnackBar(
      content: Text(result),
      backgroundColor: Colors.red, // Or any other color you prefer
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackdemo);
  }

  setState(() {
    _isLoading = false;
  });
}

_showEmptyDialog(String title) {
if (Platform.isAndroid) {
showDialog(
context: context,
barrierDismissible: false,
builder: (BuildContext context) => AlertDialog(
content: Text("$title can't be empty"),
actions: <Widget>[
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: Text("OK"))
],
),
);
} else if (Platform.isIOS) {
showDialog(
context: context,
barrierDismissible: false,
builder: (BuildContext context) => CupertinoAlertDialog(
content: Text("$title can't be empty"),
actions: <Widget>[
TextButton(
onPressed: () {
Navigator.of(context).pop();
},
child: Text("OK"))
],
),
);
}
}
  void _startBackgroundTask() {
    Workmanager().registerPeriodicTask(
      "1",
      "background_notification_task",
      frequency: Duration(minutes: 15),
    );
  }
void checkUserLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // User is signed in, navigate to the home screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyButton()));
  } else {
    // User is not signed in, do nothing (login page is already displayed)
  }
}


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _emailIdController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                GestureDetector(
  onTap: () {
    _logInUser();
  },
  child: Container(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(143, 148, 251, 1),
          Color.fromRGBO(143, 148, 251, .6),
        ],
      ),
    ),
    child: Center(
      child: Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
),

                    SizedBox(height: 70),
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
