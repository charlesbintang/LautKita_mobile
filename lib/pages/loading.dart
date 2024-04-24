import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lautkita_mobile/common/global_variables.dart';

class Loading extends StatefulWidget {
  const Loading({
    super.key,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // AuthLocalDatasource().getUserRole().then((value) {
  //   //
  //   // });
  //   print(role);
  // }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Durations.long2, () async {
      if (uid != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child("users").child(uid!);
        await userRef.once().then((snap) {
          if (snap.snapshot.value != null) {
            userName = (snap.snapshot.value as Map)['name'];
            role = (snap.snapshot.value as Map)['role'];
            isValid = (snap.snapshot.value as Map)['isValid'];

            print(userName);
            print(role);
          } else {
            FirebaseAuth.instance.signOut();
            // cMethods.displaySnackBar(
            //     "your record do not exists as a User.", context);
          }
        });
      }
    }).then((value) {
      switch (role) {
        case 'community':
          if (isValid) {
            Navigator.of(context).pushReplacementNamed('/c_home_page');
          } else {
            Navigator.of(context).pushReplacementNamed('/onboarding-community');
          }
          break;
        case 'volunteer':
          Navigator.of(context).pushReplacementNamed('/home_page');
          break;
        default:
      }
    });
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
