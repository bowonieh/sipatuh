import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:magangsipatuh/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(
          'tokenJwt'); // Menghapus token dari shared preferences / local storage
      Get.to(
        const LoginScreen(),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 90, 0),
              child: Image(
                image: AssetImage("assets/images/logoapp.png"),
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Divider(
                color: Color(0xFFC6C6C6),
                height: 16,
                thickness: 2,
                indent: 0,
                endIndent: 0,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const DashboardPages());
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: Color(0xFF57636C),
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Dashboard",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //Get.to(Siswa());
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFF57636C),
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Siswa",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //Get.to(() => Kota());
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.location_city,
                      color: Color(0xFF57636C),
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Kota Asal",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //Get.to(() => AboutApp());
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.help,
                      color: Color(0xFF57636C),
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Tentang Aplikasi",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Divider(
                      color: Color(0xFFC6C6C6),
                      height: 16,
                      thickness: 2,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _logout();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color(0xFF57636C),
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              "Keluar",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
