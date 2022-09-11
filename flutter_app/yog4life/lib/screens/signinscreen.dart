import 'package:flutter/material.dart';
import 'package:yog4life/provider/authprovider.dart';
import 'package:yog4life/screens/otpscreen.dart';
import 'package:yog4life/screens/registerscreen.dart';
import 'package:yog4life/util/utility.dart';
import 'package:yog4life/widget/auth_form.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController textEditingController = TextEditingController();

  final TextEditingController phonecodecontroller =
      TextEditingController(text: "+");

  final TextEditingController mobilenumbercontroller = TextEditingController();
  bool isLoading = false;

  void _checkphone(BuildContext context) {
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
    } else {
      String mobile =
          phonecodecontroller.text.trim() + mobilenumbercontroller.text.trim();
      Provider.of<AuthProvider>(context, listen: false)
          .authenticate(mobile, false)
          .then((response) {
        setState(() {
          isLoading = false;
        });
        if (response == "Success") {
          Navigator.of(context).pushNamed(OTPscreen.routeName);
        } else {
          Utility.showSnackbar(
              context, 'Invalid phone number or not registered');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
                          'Your Phone number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    SizedBox(
                      height: constraints.maxHeight * 0.01,
                    ),
                    const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Please confirm your country code \n and enter your phone number',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
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
                                .pushReplacementNamed(RegisterScreen.routeName);
                          },
                          child: const Text(
                            'Register',
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
                    onPressed: () => _checkphone(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: isLoading
                        ? Container(
                            child: const CircularProgressIndicator(
                                color: Colors.black))
                        : const Text(
                            'Sign in',
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
