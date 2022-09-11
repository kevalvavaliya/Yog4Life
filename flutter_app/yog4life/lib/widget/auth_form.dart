import 'package:flutter/material.dart';
import '../models/countrycode.dart';
import 'package:country_picker/country_picker.dart';

class AuthForm extends StatefulWidget {
  final BoxConstraints constraints;
  final TextEditingController textEditingController;
  final TextEditingController phonecodecontroller;
  final TextEditingController mobilenumbercontroller;

  const AuthForm(
      {required this.constraints,
      required this.mobilenumbercontroller,
      required this.phonecodecontroller,
      required this.textEditingController});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: TextField(
              showCursor: false,
              controller: widget.textEditingController,
              keyboardType: TextInputType.none,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.arrow_forward_ios, size: 18),
                labelText: "Country",
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
              onTap: () => showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  setState(() {
                    widget.textEditingController.text =
                        "${country.flagEmoji}  ${country.name}";
                    widget.phonecodecontroller.text = "+${country.phoneCode}";
                  });
                },
              ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: TextField(
              cursorHeight: 20,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                  prefixIcon: Container(
                    width: 100,
                    height: 40,
                    margin: const EdgeInsets.only(left: 10),
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 5, top: 8, bottom: 5),
                    child: TextField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          counter: Offstage(),
                          suffixIcon: VerticalDivider(
                            width: 10,
                            color: Colors.black54,
                          ),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 4,
                          )),
                      controller: widget.phonecodecontroller,
                      onChanged: (value) {
                        var c = CountryCode().PhonetoCountry(phonecode: value);
                        setState(() {
                          if (c != 0) {
                            widget.textEditingController.text =
                                c.flagEmoji + "  " + c.name;
                          } else {
                            widget.textEditingController.clear();
                          }
                        });
                      },
                    ),
                  ),
                  labelText: "Phone number",
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  counter: const Offstage()),
              controller: widget.mobilenumbercontroller,
            )),
      ],
    );
  }
}
