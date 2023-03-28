import 'package:avail_itech_hackfest/screens/auth/sign_up.dart';
import 'package:avail_itech_hackfest/utils/auth_method.dart';
import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/textstyle.dart';
import '../../widgets/textformfield.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  TextEditingController emailcontrol =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 70,
          elevation: 2,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: black,
              )),
        ),
        body: Padding(
          padding: hpad12 + hpad12 + vpad12 + vpad8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Forgot Password?",
                  style: headingBoldText,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: textFieldTitle,
                  ),
                  sBoxH10,
                  TextFieldInput(
                    textEditingController: emailcontrol,
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
                      emailcontrol.text = value!;
                    },
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: (){
                AuthMethods().forgotpassword(email: emailcontrol.text.trim());
              },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    child: const Text('Send Link',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color:Colors.white)),
                  )),
              sBoxH20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: grey,
                      thickness: 2,

                    ),
                  ),

                  Text("or",
                  style:TextStyle(
                    color: grey,
                    fontSize: 20
                  ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Divider(
                      color: grey,
                      thickness: 2,

                    ),
                  ),
                ],
              ),
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
    );
  }
}
