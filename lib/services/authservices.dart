import 'dart:convert';

import 'package:get/get.dart';
import 'package:magangsipatuh/config/constants.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:magangsipatuh/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dynamic apiUrl = Uri.parse(Constants.baseUrl + Constants.checklogin);
    var token = prefs.getString('tokenJwt') ?? '';
    //Check State get
    final response = await http.get(apiUrl, headers: {'Cookie': token});
     Map<String, dynamic> responseData = json.decode(response.body);
     if(responseData['status'] == true){
      Get.to(() => const DashboardPages());
     }else{
      Get.to(() => const LoginScreen());
     }
  }
}
