import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medeasy/src/bloc/user_auth_bloc.dart';
import 'package:medeasy/src/model/user_model.dart';
import 'package:medeasy/src/resource/intent_helper.dart';
import 'package:medeasy/src/resource/user_auth.dart';
import 'package:medeasy/src/resource/user_provider.dart';
import 'package:medeasy/src/screen/appointments.dart';
import 'package:medeasy/src/screen/life_reminder.dart';
import 'package:medeasy/src/screen/user_details.dart';
import 'package:medeasy/src/widget/loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IntentHelper _intentHelper;
  UserModel _user;

  @override
  void initState() {
    _intentHelper = IntentHelper();
    UserProvider.instance.user.then((value) {
      _user = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('HomePage'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                UserAuth().signOut().then(
                      (value) => UserAuthBloc().unauthenticate(),
                    );
              },
            ),
          ],
        ),
        body: _user != null
            ? GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserDetails(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              size: 30,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Profile',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Appointments(),
                      ));
                    },
                    child: Card(
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('image/appointment.png', height: 30),
                            SizedBox(height: 16),
                            Text(
                              'Appointments',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // File file = await showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return SimpleDialog(
                      //       title: Text('Choose Image using ...'),
                      //       children: <Widget>[
                      //         FlatButton(
                      //           child: Text('Camera'),
                      //           onPressed: () async {
                      //             File f = await ImagePicker.pickImage(
                      //               source: ImageSource.camera,
                      //             );
                      //             Navigator.of(context).pop(f);
                      //           },
                      //         ),
                      //         FlatButton(
                      //           child: Text('Gallery'),
                      //           onPressed: () async {
                      //             File f = await ImagePicker.pickImage(
                      //               source: ImageSource.gallery,
                      //             );
                      //             Navigator.of(context).pop(f);
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                      File file = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      if (file != null) {
                        String allergies = "";
                        if (_user.allergy.length == 0)
                          allergies = "None\n";
                        else
                          _user.allergy.forEach((a) {
                            allergies += a + "\n";
                          });

                        String medicalHistory = "";
                        if (_user.medicalHistory.length == 0)
                          medicalHistory = "None\n";
                        else
                          _user.medicalHistory.forEach((a) {
                            medicalHistory += a + "\n";
                          });

                        String ongoingMedication = "";
                        if (_user.ongoingMedication.length == 0)
                          ongoingMedication = "None\n";
                        else
                          _user.ongoingMedication.forEach((a) {
                            ongoingMedication += a + "\n";
                          });
                        String identification = _user.identification.isEmpty
                            ? 'None'
                            : _user.identification;
                        String message =
                            "*Name*: ${_user.name}\n\n*Email*: ${_user.email}\n\n" +
                                "*Address*: ${_user.address}\n\n*Blood Group*: ${_user.blood}\n\n" +
                                "*Unique Body Feature*: $identification\n\n*Allergic to*:\n$allergies\n" +
                                "*Previous Medical Records*: \n$medicalHistory\n*Ongoing Medication*:\n$ongoingMedication";
                        await _intentHelper.eMeds(file.path, message);
                      }
                    },
                    child: Card(
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('image/emeds.png', height: 30),
                            SizedBox(height: 16),
                            Text(
                              'e-Meds',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LifeReminder(),
                      ));
                    },
                    child: Card(
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('image/heart.png', height: 30),
                            SizedBox(height: 8),
                            Text(
                              'Life Reminder\nSystem',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _intentHelper.callAmbulance();
                    },
                    child: Card(
                      elevation: 3,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('image/ambulance.png', height: 38),
                            SizedBox(height: 8),
                            Text(
                              'Ambulance\non Click',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Loader(),
      ),
    );
  }
}
