import 'package:flutter/material.dart';
import 'package:yog4life/provider/authprovider.dart';
import 'package:yog4life/screens/otpscreen.dart';
import 'package:yog4life/screens/signinscreen.dart';
import 'package:yog4life/util/utility.dart';
import 'package:yog4life/widget/auth_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController phonecodecontroller =
      TextEditingController(text: "+");

  final TextEditingController mobilenumbercontroller = TextEditingController();

  final TextEditingController usernamecontroller = TextEditingController();
  var isLoading = false;

  void _checkdetails() {
    setState(() {
      isLoading = true;
    });
    if (mobilenumbercontroller.text.length != 10) {
      Utility.showSnackbar(context, 'Invalid phone number');
      setState(() {
        isLoading = false;
      });
    } else if (textEditingController.text.isEmpty) {
      Utility.showSnackbar(context, 'Invalid country');
      setState(() {
        isLoading = false;
      });
    } else if (usernamecontroller.text.isEmpty) {
      Utility.showSnackbar(context, 'Invalid username');
    } else {
      String mobile =
          phonecodecontroller.text.trim() + mobilenumbercontroller.text.trim();
      Provider.of<AuthProvider>(context, listen: false)
          .authenticate(mobile, true, username: usernamecontroller.text)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value == "Success") {
          Navigator.of(context).pushReplacementNamed(OTPscreen.routeName);
        } else {
          Utility.showSnackbar(context, 'Registration failed');
        }
      });
    }
  }

  @override
  void dispose() {
    phonecodecontroller.dispose();
    textEditingController.dispose();
    usernamecontroller.dispose();
    mobilenumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FittedBox(
                        alignment: Alignment.center,
                        child: Text(
                          'Let\'s Sign you up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    SizedBox(
                      height: constraints.maxHeight * 0.01,
                    ),
                    const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Please Enter your name,country code \n and enter your phone number',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40),
                        child: TextField(
                            controller: usernamecontroller,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "User name",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                            ))),
                    AuthForm(
                      constraints: constraints,
                      mobilenumbercontroller: mobilenumbercontroller,
                      phonecodecontroller: phonecodecontroller,
                      textEditingController: textEditingController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.8,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        child: FittedBox(
                          child: Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(SignInScreen.routeName);
                          },
                          child: const Text(
                            'Sign in',
                          )),
                    ]),
              ),
              Container(
                width: constraints.maxWidth * 0.8,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextButton(
                    onPressed: _checkdetails,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
