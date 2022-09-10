
import 'package:flutter/material.dart';
import 'package:yog4life/models/authmodel.dart';
import 'package:yog4life/provider/authprovider.dart';
import 'package:yog4life/screens/homepage.dart';
import 'package:yog4life/screens/mainhomescreen.dart';
import 'package:yog4life/screens/otpscreen.dart';
import 'package:yog4life/screens/registerscreen.dart';
import 'package:yog4life/screens/signinscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> tryLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("user")) {
      return Future<String>(() {
        return "true";
      });
    }
    return Future<String>(() {
      return "false";
    });
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AuthProvider(),
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            theme: ThemeData(
                fontFamily: 'Rubik',
                textTheme: ThemeData.light().textTheme.copyWith(
                    headline5: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik'))),
            home: FutureBuilder(
              future: auth.tryLogin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return HomePage();
                }
                if (snapshot.data == false) {
                  return HomePage();
                } else {
                  return MainHomeScreen();
                }
              },
            ),
            routes: {
              SignInScreen.routeName: (context) => SignInScreen(),
              RegisterScreen.routeName: (context) => RegisterScreen(),
              OTPscreen.routeName: (context) => OTPscreen(),
              MainHomeScreen.routeName: (context) => MainHomeScreen()
            },
          ),
        ));
  }
}
