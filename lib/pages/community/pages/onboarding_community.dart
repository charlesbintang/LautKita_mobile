import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingCommunity extends StatelessWidget {
  const OnboardingCommunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Image.asset(
                'assets/images/logo-lautkita.png',
                height: 39.h,
              ),
            ),
            Flexible(
              child: Image.asset(
                'assets/images/shield.png',
                height: 260.h,
              ),
            ),
            const Text(
              "Create Community",
              style: TextStyle(
                color: Color(0xFF262626),
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: SizedBox(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: const Column(
                    children: [
                      Text(
                        "Establish a community to support a healthy ocean.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                      Text(
                        "Indonesia is rich in ocean and resources.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.only(
                        left: 24, top: 14, right: 24, bottom: 14),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(0, 168, 204, 1)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Let\'s Go',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
