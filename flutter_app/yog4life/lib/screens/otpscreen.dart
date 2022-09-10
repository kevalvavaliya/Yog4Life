import 'package:http/http.dart';
import 'package:yog4life/provider/authprovider.dart';
import 'package:yog4life/screens/mainhomescreen.dart';
import 'package:yog4life/util/utility.dart';

import '../widget/OTPBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPscreen extends StatefulWidget {
  static const routeName = '/otpscreen';

  @override
  State<OTPscreen> createState() => _OTPscreenState();
}

class _OTPscreenState extends State<OTPscreen> {
  TextEditingController otpbox1 = TextEditingController();
  TextEditingController otpbox2 = TextEditingController();
  TextEditingController otpbox3 = TextEditingController();
  TextEditingController otpbox4 = TextEditingController();
  bool isLoading = false;

  void checkOTP() {
    setState(() {
      isLoading = true;
    });
    String otp = otpbox1.text + otpbox2.text + otpbox3.text + otpbox4.text;
    if (otp.length == 4) {
      Provider.of<AuthProvider>(context,listen: false).verifyOTP(otp).then((response) {
        setState(() {
          isLoading = false;
        });
        print(response);
        if (response == "Success") {
          Navigator.of(context).pushReplacementNamed(MainHomeScreen.routeName);
        } else {
          Utility.showSnackbar(context, 'Invalid otp');
        }
      });
    } else {
      Utility.showSnackbar(context, 'Enter otp');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    otpbox1.dispose();
    otpbox2.dispose();
    otpbox3.dispose();
    otpbox4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                        "https://img.icons8.com/dusk/64/000000/sms-token.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Enter code',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Enter the otp sent to your mobile number '),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OTPBox(controller: otpbox1),
                          const SizedBox(
                            width: 10,
                          ),
                          OTPBox(
                            controller: otpbox2,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OTPBox(controller: otpbox3),
                          const SizedBox(
                            width: 10,
                          ),
                          OTPBox(controller: otpbox4),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.8,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextButton(
                    onPressed: checkOTP,
                    autofocus: false,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text(
                            'Verify',
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
