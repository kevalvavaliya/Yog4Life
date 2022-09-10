import 'package:yog4life/models/authmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yog4life/screens/mainhomescreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yog4life/util/utility.dart';

class AuthProvider with ChangeNotifier {
  AuthModel authUser = AuthModel();
  var isTokenset;
  final String URL = 'https://LittleBewitchedPoints.harrykanani.repl.co';

  Future<dynamic> authenticate(String mobile, bool isRegister,
      {String username = ''}) async {
    final response = await http.post(Uri.parse('${URL}/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobileNumber": mobile,
          "isRegister": isRegister,
          "username": username,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> extracteddata = json.decode(response.body);
      if (extracteddata['message'] == "OTP sent successfully") {
        authUser.setMobileNo = mobile;
        return Future(() => "Success");
      }
      return Future(() => "Fail");
    } else {
      return Future(() => "Fail");
    }
  }

  Future<String> verifyOTP(String otp) async {
    final response = await http.post(Uri.parse('${URL}/auth/otp/verify'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "mobileNumber": authUser.getMobileNo,
          "otp": otp,
          "isRegister": false
        }));

    if (response.statusCode != 200) {
      return "Fail";
    }
    Map<String, dynamic> extracteddata = json.decode(response.body);
    if (!extracteddata.containsKey('message')) {
      return "Fail";
    }
    if (extracteddata['message'].toString().trim() ==
        'OTP verified successfully') {
      final prefMap = Map.from(extracteddata['data']);
      prefMap.remove('user_id');

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("user", json.encode(prefMap));
      print(prefMap);
      return "Success";
    }
    return "Fail";
  }

  Future<bool> tryLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("user")) {
        return false;
      }
      var userData = jsonDecode(prefs.getString("user") as String);
      authUser.setMobileNo = userData['mobileNumber'].toString();
      authUser.setToken = userData['token'];
      authUser.setname = userData['username'];
      print(authUser.getMobileNo + authUser.getname);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
