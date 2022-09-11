import 'package:flutter/material.dart';
import 'package:yog4life/screens/registerscreen.dart';
import 'package:yog4life/screens/signinscreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Image.asset(
                            'assets/images/yogagirl.gif',
                            fit: BoxFit.cover,
                            height: 420,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        FittedBox(
                          child: Text('Welcome to Yoga\nFor Life',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                          child: Text(
                            'Yoga is not just a pose.Yoga is a process\n of balancing your life and makes you strong.\nTry it if you want to know your conscience',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                                fontFamily: 'Rubik'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 50),
                    child: Container(
                      height: 50,
                      width: constraints.maxWidth * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 248, 215, 117)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            RegisterScreen.routeName);
                                      },
                                      style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          backgroundColor: Colors.amber,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 30)),
                                      child: const FittedBox(
                                          child: Text('Register'))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: double.infinity,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(SignInScreen.routeName);
                                    },
                                    style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 30)),
                                    child: const FittedBox(
                                        child: Text('Sign in'))),
                              ),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
