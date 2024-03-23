import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment(0.0, -0.3),
                    child:
      
                        ///***If you have exported images you must have to copy those images in assets/images directory.
                        Image(
                      image: AssetImage("assets/images/logoapp.png"),
                      height: 148,
                      width: 148,
                      fit: BoxFit.fill,
                      
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "AKADEMIK",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 32,
                      color: Color(0xff3c58ee),
                    ),
                  ),
                ),
              ),
              Text(
                "App",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 40,
                  color: Color(0xff3b57e7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}