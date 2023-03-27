import 'package:avail_itech_hackfest/screens/contributers/terms_conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avail_itech_hackfest/widgets/textformfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/textstyle.dart';
import 'contributer_intro.dart';

class OrganizationForm extends StatefulWidget {
  const OrganizationForm({Key? key}) : super(key: key);

  @override
  State<OrganizationForm> createState() => _OrganizationFormState();
}

class _OrganizationFormState extends State<OrganizationForm> {
  final TextEditingController tradeName = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController address3 = TextEditingController();

  String stateValue = "";
  String cityValue = "";

  bool stateselected = false;
  bool cityselected = false;

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
                onPressed: getHotelInfo,
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
                      'Trade Name',
                      style: textFieldTitle,
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: red, fontSize: 24),
                    ),
                  ],
                ),
                sBoxH10,
                FormsField(
                  textEditingController: tradeName,
                  hintText: "Name",
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                  },
                  save: (value) {
                    tradeName.text = value!;
                  },
                ),
                Row(
                  children: [
                    Text(
                      'Business Location',
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
                  stateDropdownLabel: "State",
                  cityDropdownLabel: "City",
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
                sBoxH10,
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
                FormsField(
                  textEditingController: address1,
                  hintText: "House No. / Street",
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the House No. / Street';
                    }
                  },
                  save: (value) {
                    address1.text = value!;
                  },
                ),
                FormsField(
                  textEditingController: address2,
                  hintText: "Locality",
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Locality';
                    }
                  },
                  save: (value) {
                    address2.text = value!;
                  },
                ),
                FormsField(
                  textEditingController: address3,
                  hintText: "City",
                  validate: (value) {
                    if (value == null || value.isEmpty) {
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

  getHotelInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (stateselected &&
        cityselected &&
        tradeName.text.isNotEmpty &&
        address1.text.isNotEmpty &&
        address2.text.isNotEmpty &&
        address3.text.isNotEmpty) {
      await _firestore.collection("users").doc(uid).update({
        'tradeName': tradeName.text,
        'AddressLine1': address1.text,
        'AddressLine2': address2.text,
        'AddressLine3': address3.text,
        'hotelState': stateValue.toString(),
        'hotelCity': cityValue.toString()
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
