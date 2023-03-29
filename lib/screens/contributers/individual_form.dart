import 'package:avail_itech_hackfest/widgets/textformfield.dart';
import 'package:avail_itech_hackfest/screens/contributers/terms_conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/textstyle.dart';
import 'contributer_intro.dart';

class IndividualForm extends StatefulWidget {
  const IndividualForm({Key? key}) : super(key: key);

  @override
  State<IndividualForm> createState() => _IndividualFormState();
}

class _IndividualFormState extends State<IndividualForm> {
  final TextEditingController name = TextEditingController();
  final TextEditingController aadhar = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController address3 = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController intialdateval = TextEditingController();

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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContributerIntro(),
                  ),
                  (route) => false);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: black,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: getUserInfo,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: HexColor('#FEED5F'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                child: Text('Next',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: black)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: vpad12 + hpad12,
          child: Form(
            key: _key,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Name',
                      style: textFieldTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: red, fontSize: 24),
                    ),
                  ],
                ),
                sBoxH10,
                TextFieldInput(
                  textEditingController: name,
                  hintText: "Name",
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  save: (value) {
                    name.text = value!;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Aadhar Number',
                      style: textFieldTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: red, fontSize: 24),
                    ),
                  ],
                ),
                sBoxH10,
                TextFieldInput(
                  textEditingController: aadhar,
                  hintText: "Aadhar Number",
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Aadhar Number';
                    }
                    if (value.length < 16 || value.length > 16) {
                      return 'Please enter a valid Aadhar number (16 digits)';
                    }
                  },
                  keyboard: TextInputType.number,
                  save: (value) {
                    aadhar.text = value!;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Address',
                      style: textFieldTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: red, fontSize: 24),
                    ),
                  ],
                ),
                sBoxH10,
                TextFieldInput(
                  textEditingController: address1,
                  hintText: "House No. / Street",
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the House No. / Street';
                    }
                  },
                  save: (value) {
                    address1.text = value!;
                  },
                ),
                TextFieldInput(
                  textEditingController: address2,
                  hintText: "Locality",
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Locality';
                    }
                  },
                  save: (value) {
                    address2.text = value!;
                  },
                ),
                TextFieldInput(
                  textEditingController: address3,
                  hintText: "City",
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the City';
                    }
                  },
                  save: (value) {
                    address3.text = value!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  getUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (name.text.isNotEmpty &&
        aadhar.text.isNotEmpty &&
        address1.text.isNotEmpty &&
        address2.text.isNotEmpty &&
        address3.text.isNotEmpty) {
      await _firestore.collection("users").doc(uid).update({
        'name': name.text,
        'aadharNum': aadhar.text,
        'AddressLine1': address1.text,
        'AddressLine2': address2.text,
        'AddressLine3': address3.text
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const TermsAndCondtion(),
          ),
          (route) => false);
    } else {
      Fluttertoast.showToast(msg: 'All fields are mandatory');
    }
  }
}
