import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/config/constants.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:magangsipatuh/services/authservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState(){
      super.initState();
      AuthService.checkLoginState();
  }
  
  var isLoading = false.obs;
  Future<void> login() async {
    isLoading.value = true;
    final dynamic apiUrl = Uri.parse(Constants.baseUrl+Constants.login);
    Map<String, String> postData = {
      'username': emailController.text,
      'password': passwordController.text
    };
    try {
      final response = await http.post(
                        apiUrl, 
                        body: postData, 
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    );
      Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        final String? cookies = response.headers['set-cookie'];

        final List<String> arrCookies = cookies!.split(';');

        String? phpSessionId;

        for (String cookie in arrCookies) {
          if (cookie.trim().startsWith('PHPSESSID=')) {
            phpSessionId = cookie.trim();
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('tokenJwt', phpSessionId);
            break;
          }
        }
        Get.snackbar('Sukses', 'Login Berhasil',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.add_alert));
        isLoading.value = false;
        Get.to(() => const DashboardPages());
      } else {
        Get.snackbar('Error', 'Login Gagal',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert));
        isLoading.value = false;
      }
    } catch (error) {
      Get.snackbar('error', 'Error : $error',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert));
      isLoading.value = false;
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PasswordVisibility = true.obs;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35000000000000003,
            decoration: BoxDecoration(
              color: const Color(0xff3a57e8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0x39958282), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                        image: const AssetImage("assets/images/newlogo.png"),
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.4,
                        fit: BoxFit.fill,
                      ),
                      const Text(
                        "SiPatuh App - SMK UBIG MALANG",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Color(0xff3b57e7),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 4),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: emailController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "email tidak boleh kosong";
                              }
                              return null;
                            },
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(120, 208, 206, 206),
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(120, 208, 206, 206),
                                    width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(120, 208, 206, 206),
                                    width: 1),
                              ),
                              hintText: "Email",
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff494646),
                              ),
                              filled: true,
                              fillColor: const Color(0xb7f8f7f7),
                              isDense: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(7, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => TextFormField(
                          controller: passwordController,
                          obscureText: PasswordVisibility.value,
                          autofillHints: const [AutofillHints.password],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(120, 208, 206, 206),
                                  width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(120, 208, 206, 206),
                                  width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(120, 208, 206, 206),
                                  width: 1),
                            ),
                            hintText: "password",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff494646),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff8f7f7),
                            isDense: false,
                            contentPadding:
                                const EdgeInsets.fromLTRB(7, 0, 0, 0),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                PasswordVisibility.value =
                                    !PasswordVisibility.value;
                              },
                              child: Icon(
                                  PasswordVisibility.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xff212435),
                                  size: 24),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Obx(
                          () => MaterialButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                login();
                                //prosesLogin
                                //Get.to(Dashboard())
                                /*
                                Map<String, String> postData = {
                                  'username': emailController.text,
                                  'password': passwordController.text
                                };
                                var url = Uri.parse(
                                    constantsApi.baseUrl + constantsApi.login);
                                var response =
                                    await http.post(url, body: postData);
                          
                                Map<String, dynamic> responseData =
                                    json.decode(response.body);
                                if (responseData['success']) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Login Berhasil, kamu akan diarahkan ke dashboard'),
                                    backgroundColor: Colors.green,
                                  ));
                                  //Redirect
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Opps, ada kesalahan. Kamu gagal login'),
                                    backgroundColor: Colors.red,
                                  ));
                                }*/
                              }
                            },
                            color: const Color(0xff3a57e8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            padding: const EdgeInsets.all(16),
                            textColor: const Color(0xffffffff),
                            height: 40,
                            minWidth: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                isLoading.value
                                    ? SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                      ),
                                    )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}