import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/firebase_options.dart';
import 'package:messaging_app/pages/home_page.dart';
import 'package:messaging_app/pages/login_page.dart';
import 'package:uuid/uuid.dart';

import 'models/FirebaseHelper.dart';
import 'models/UserModel.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    //Logged in
    UserModel? currentUserModel =
        await FirebaseHelper.getUserById(currentUser.uid);
    if (currentUserModel == null) {
      debugPrint("directly logging in");
      runApp(MyAppLoggedIn(
          userModel: currentUserModel!, firebaseUser: currentUser));
    } else {
      debugPrint("running else condition");
      runApp(const MyApp());
    }
  } else {
    //Not logged in
    debugPrint("going to login page");
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}
