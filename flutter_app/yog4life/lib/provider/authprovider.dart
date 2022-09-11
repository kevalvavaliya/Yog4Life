import 'package:yog4life/models/authmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yog4life/util/utility.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  static AuthModel authUser = AuthModel();

  Future<dynamic> authenticate(String mobile, bool isRegister,
      {String username = ''}) async {
    final response = await http.post(Uri.parse('${Utility.URL}/auth/register'),
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
    final response = await http.post(
        Uri.parse('${Utility.URL}/auth/otp/verify'),
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
      // print(prefMap);
      print(extracteddata);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user", json.encode(prefMap));
      authUser.setMobileNo = prefMap['mobileNumber'].toString();
      authUser.setToken = prefMap['token'];
      authUser.setname = prefMap['username'];
      authUser.setuserid = prefMap['user_id'];
      authUser.setprofilePIC = prefMap['profile_pic'];
      // print(authUser.getMobileNo + authUser.getname);
      // print("USERID" + authUser.getuserID);
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
      authUser.setuserid = userData['user_id'];
      authUser.setprofilePIC = userData['profile_pic'];
      // print(
      //     "Number"+authUser.getMobileNo + authUser.getname + authUser.getuserID);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> Logout() async {
    final r = await http.post(Uri.parse('${Utility.URL}/auth/logout'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"token": authUser.gettoken}));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    print(r.body);
  }
}
