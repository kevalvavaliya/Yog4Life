import 'package:flutter/material.dart';
import 'package:yog4life/provider/feedaddprovider.dart';
import 'package:yog4life/provider/feedprovider.dart';
import './provider/authprovider.dart';
import './provider/chat_provider.dart';
import './screens/chatscreen.dart';
import './screens/feedaddscreen.dart';
import './screens/homepage.dart';
import './screens/feedscreen.dart';
import './screens/navbarscreen.dart';
import './screens/otpscreen.dart';
import './screens/profilescreen.dart';
import './screens/registerscreen.dart';
import './screens/signinscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: AuthProvider()),
          ChangeNotifierProvider.value(value: ChatSession()),
          ChangeNotifierProvider.value(value: FeedAddprovider()),
          ChangeNotifierProvider.value(value: FeedProvider()),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.amber,
                fontFamily: 'Rubik',
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline5: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik'),
                      bodyText1: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Rubik',
                        color: Colors.black,
                      ),
                    )),
            home: FutureBuilder(
              future: auth.tryLogin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return HomePage();
                }
                if (snapshot.data == false) {
                  return HomePage();
                } else {
                  return NavbarScreen();
                }
              },
            ),
            routes: {
              SignInScreen.routeName: (context) => SignInScreen(),
              RegisterScreen.routeName: (context) => RegisterScreen(),
              OTPscreen.routeName: (context) => OTPscreen(),
              FeedScreen.routeName: (context) => FeedScreen(),
              ChatScreen.routeName: (context) => ChatScreen(),
              FeedAddScreen.routeName: (context) => FeedAddScreen(),
              ProfileScreen.routeName: (context) => ProfileScreen(),
              NavbarScreen.routeName: (context) => NavbarScreen()
            },
          ),
        ));
  }
}
