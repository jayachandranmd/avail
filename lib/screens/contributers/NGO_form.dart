import 'package:avail_itech_hackfest/screens/contributers/contributer_intro.dart';
import 'package:avail_itech_hackfest/screens/contributers/terms_conditions.dart';
import 'package:avail_itech_hackfest/utils/constants.dart';
import 'package:avail_itech_hackfest/widgets/textformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/colors.dart';
import '../../utils/textstyle.dart';

class NGOForm extends StatefulWidget {
  const NGOForm({Key? key}) : super(key: key);

  @override
  State<NGOForm> createState() => _NGOFormState();
}

class _NGOFormState extends State<NGOForm> {
  final TextEditingController ngo_name = TextEditingController();
  final TextEditingController ngo_type = TextEditingController();
  final TextEditingController ngo_id = TextEditingController();
  String stateValue = "";
  String cityValue = "";

  bool stateselected = false;
  bool cityselected = false;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
                  onPressed: getNgoInfo,
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
            ),
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
                        'Name of NGO',
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
                    textEditingController: ngo_name,
                    hintText: "Name",
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    save: (value) {
                      ngo_name.text = value!;
                    },
                  ),
                  sBoxH10,
                  Row(
                    children: [
                      Text(
                        'Unique NGO ID',
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
                    textEditingController: ngo_id,
                    hintText: "NGO ID",
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some number';
                      }
                    },
                    keyboard: TextInputType.phone,
                    save: (value) {
                      ngo_id.text = value!;
                    },
                  ),
                  sBoxH10,
                  Row(
                    children: [
                      Text(
                        'NGO Type',
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
                    textEditingController: ngo_type,
                    hintText: "NGO Type",
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some number';
                      }
                    },
                    keyboard: TextInputType.name,
                    save: (value) {
                      ngo_type.text = value!;
                    },
                  ),
                  sBoxH10,
                  Row(
                    children: [
                      Text(
                        'NGO Location',
                        style: textFieldTitle,
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: red, fontSize: 24),
                      ),
                    ],
                  ),
                  sBoxH10,
                  CSCPicker(
                    defaultCountry: CscCountry.India,
                    disableCountry: true,


                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    stateDropdownLabel: "NGO State",
                    cityDropdownLabel: "NGO City",
                    onCountryChanged: (value) {},
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value.toString();
                        stateselected = true;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value.toString();
                        cityselected = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getNgoInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (stateselected &&
        cityselected &&
        ngo_name.text.isNotEmpty &&
        ngo_id.text.isNotEmpty &&
        ngo_type.text.isNotEmpty) {
      await _firestore.collection("users").doc(uid).update({
        'ngoName': ngo_name.text,
        'ngoId': ngo_id.text,
        'ngoType': ngo_type.text,
        'ngoState': stateValue.toString(),
        'ngoCity': cityValue.toString()
        //continue from here
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermsAndCondtion(),
          ));
    } else {
      Fluttertoast.showToast(msg: 'All fields are mandatory');
    }
  }
}
