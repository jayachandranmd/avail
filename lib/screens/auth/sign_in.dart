import 'package:avail_itech_hackfest/utils/auth_method.dart';
import 'package:avail_itech_hackfest/utils/colors.dart';
import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:avail_itech_hackfest/utils/textstyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/textformfield.dart';
import '../home/homepage.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool _isObscure = true;

  void signinUser() async {}
  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: hpad12 + hpad12 + vpad12 + vpad8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Login",
                    style: headingBoldText,
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/avail-38482.appspot.com/o/logo.png?alt=media&token=f65ddf57-2e6d-4908-bffb-4b0f650aa378',
                    height: 120,
                  ),
                ],
              ),
              sBoxH60,
              Form(
                key: key,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: textFieldTitle,
                      ),
                      sBoxH10,
                      TextFieldInput(
                        textEditingController: emailcontroller,
                        hintText: 'someone@example.com',
                        validate: (value) {
                          if (value!.isEmpty) {
                            return ("Please enter your email");
                          }
                          // reg expression for email validation
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please enter a valid email");
                          }
                          return null;
                        },
                        save: (value) {
                          emailcontroller.text = value!;
                        },
                      ),
                      Text(
                        'Password',
                        style: textFieldTitle,
                      ),
                      sBoxH10,
                      TextFieldInput(
                        textEditingController: passwordcontroller,
                        hintText: '*****',
                        isPass: _isObscure,
                        validate: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },
                        save: (value) {
                          passwordcontroller.text = value!;
                        },
                        suffixIcon: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: black,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ]),
              ),
              sBoxH60,
              sBoxH10,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      String res = await AuthMethods().loginUser(
                          email: emailcontroller.text.trim(),
                          password: passwordcontroller.text.trim());
                      if (res == "success") {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("isLoggedIn", true);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false);
                      } else {
                        Fluttertoast.showToast(msg: "Some error occurred");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text('Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
              sBoxH60,
              sBoxH20,
              sBoxH30,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: black, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    child: InkWell(
                      child: Text('Sign up',
                          style: TextStyle(
                              color: blue,
                              fontSize: 18,
                              decoration: TextDecoration.underline)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
