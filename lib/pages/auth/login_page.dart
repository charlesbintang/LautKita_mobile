import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lautkita_mobile/pages/auth/forgot_password_page.dart';
import 'package:lautkita_mobile/pages/auth/sign_up_page.dart';
import 'package:lautkita_mobile/pages/loading.dart';

import '../../bloc/login/login_bloc.dart';
import '../../common/common_methods.dart';
import '../../data/datasources/auth_local_datasources.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  CommonMethods cMethods = CommonMethods();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  checkConnectivity() {
    cMethods.checkConnectivity(context);

    validateForm();
  }

  void validateForm() {
    if (_formKeyLogin!.currentState!.validate()) {
      _formKeyLogin!.currentState!.save();

      String email = _emailController!.text.trim();
      String password = _passwordController!.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill the email field'),
          backgroundColor: Colors.red,
        ));
      } else if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill the password field'),
          backgroundColor: Colors.red,
        ));
      } else {
        // final model = LoginRequestModel(
        //   email: email,
        //   password: password,
        // );
        // context.read<LoginBloc>().add(LoginEvent.login(model));
        loginUser(email, password);
      }
    }
  }

  void loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => Navigator.pushReplacementNamed(context, '/loading'),
          );
    } on FirebaseAuthException catch (e) {
      onErrorLogin(e);
    }
  }

  onErrorLogin(FirebaseAuthException e) {
    print('Failed with error code: ${e.code}');
    // cMethods.displaySnackBar("${e.message}", context, color: Colors.red);
    // if (e.code == 'user-not-found') {
    //   cMethods.displaySnackBar("User Not Found", context, color: Colors.red);
    // } else if (e.code == 'wrong-password') {
    //   cMethods.displaySnackBar("Wrong Password", context, color: Colors.red);
    // }
    switch (e.code) {
      case 'user-not-found':
        cMethods.displaySnackBar("User Not Found", context, color: Colors.red);
        break;
      case 'wrong-password':
        cMethods.displaySnackBar("Wrong Password", context, color: Colors.red);
        break;
      case 'invalid-credential':
        cMethods.displaySnackBar("User Not Found", context, color: Colors.red);
        break;
      default:
        cMethods.displaySnackBar("${e.message}", context, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/sign-in.png'),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LAUTKITA',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 34,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Marine Ecosystem Conservation Platform',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Montserrat'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                key: _formKeyLogin,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black54),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          filled: true,
                          fillColor: const Color.fromRGBO(243, 245, 247, 1),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.black38,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                          hintText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: passwordVisible,
                        style: const TextStyle(color: Colors.black54),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          filled: true,
                          fillColor: const Color.fromRGBO(243, 245, 247, 1),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintStyle: const TextStyle(
                              color: Colors.black38,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            color: Colors.black38,
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          'FORGOT PASSWORD',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 168, 204, 1),
                              fontSize: 14,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            state.maybeWhen(
                              orElse: () {},
                              loaded: (data) async {
                                await AuthLocalDatasource().saveAuthData(data);
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Loading();
                                }), (route) => false);
                              },
                              error: (message) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.red,
                                ));
                              },
                            );
                          },
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () {
                                return ElevatedButton(
                                  onPressed: () => checkConnectivity(),
                                  style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.only(
                                          left: 24,
                                          top: 14,
                                          right: 24,
                                          bottom: 14),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(0, 168, 204, 1)),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'OR LOG IN BY',
                        style: TextStyle(
                          color: Color.fromRGBO(96, 96, 96, 1),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromRGBO(236, 237, 255, 1),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/icons/google.svg',
                                  width: 24, height: 24, fit: BoxFit.scaleDown),
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 15),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromRGBO(236, 237, 255, 1),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                  'assets/icons/facebook.svg',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: 'SIGN UP',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 168, 204, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
