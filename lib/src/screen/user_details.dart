import 'package:flutter/material.dart';
import 'package:medeasy/src/bloc/user_auth_bloc.dart';
import 'package:medeasy/src/model/user_model.dart';
import 'package:medeasy/src/resource/user_database_helper.dart';
import 'package:medeasy/src/resource/user_provider.dart';
import 'package:medeasy/src/widget/loader.dart';
import 'package:medeasy/src/widget/multi_input.dart';
import 'package:medeasy/src/widget/wait_dialog.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  UserModel _user;
  GlobalKey<FormState> _formKey;
  TextEditingController _name, _address, _blood, _identification;
  List<String> _allergy, _medicalHistory, _ongoingMedication;
  TextStyle _header;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _header = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    );
    UserProvider.instance.user.then((value) {
      setState(() {
        _name = TextEditingController(text: value.name);
        _address = TextEditingController(text: value.address);
        _blood = TextEditingController(text: value.blood);
        _identification = TextEditingController(text: value.identification);
        _allergy = value.allergy;
        _ongoingMedication = value.ongoingMedication;
        _medicalHistory = value.medicalHistory;
        _user = value;
      });
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
          title: Text('Your Details'),
        ),
        body: _user == null
            ? Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Full Name', style: _header),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Your Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (s) {
                            if (s == null || s.isEmpty)
                              return "Name cannot be empty";
                            else
                              return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Text('Email', style: _header),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Your Name',
                          ),
                          enabled: false,
                          initialValue: _user.email,
                        ),
                        SizedBox(height: 24),
                        Text('Address', style: _header),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _address,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Your Address',
                          ),
                        ),
                        SizedBox(height: 24),
                        Text('Blood Group', style: _header),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _blood,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Your Blood Group',
                          ),
                          validator: (s) {
                            if (s == null || s.isEmpty)
                              return "Blood Group cannot be empty";
                            else if (s != 'A+' &&
                                s != 'B+' &&
                                s != 'AB+' &&
                                s != 'O+' &&
                                s != 'A-' &&
                                s != 'B-' &&
                                s != 'AB-' &&
                                s != 'O-')
                              return "Enter a valid blood group like A+, AB+, etc.";
                            else
                              return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Text('Unique Body Identification', style: _header),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _identification,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Your Unique Feature',
                          ),
                        ),
                        SizedBox(height: 24),
                        MultiInput(
                          title: 'Allergies',
                          initialValue: _user.allergy,
                          onChanged: (l) {
                            _allergy = l;
                          },
                        ),
                        SizedBox(height: 24),
                        MultiInput(
                          title: 'Medical History',
                          initialValue: _user.medicalHistory,
                          onChanged: (l) {
                            _medicalHistory = l;
                          },
                        ),
                        SizedBox(height: 24),
                        MultiInput(
                          title: 'Ongoing Medication',
                          initialValue: _user.ongoingMedication,
                          onChanged: (l) {
                            _ongoingMedication = l;
                          },
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: RaisedButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: Text('Update'),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                Map<String, dynamic> details = {
                                  'name': _name.text,
                                  'email': _user.email,
                                  'blood': _blood.text,
                                  'address': _address.text,
                                  'photoUrl': _user.photoUrl,
                                  'identification': _identification.text,
                                  'allergy': _allergy,
                                  'medicalHistory': _medicalHistory,
                                  'ongoingMedication': _ongoingMedication,
                                };
                                WaitDialog wd = WaitDialog(context);
                                try {
                                  wd.showWaitDialog(false);
                                  await UserDatabaseHelper()
                                      .updateUser(_user.email, details);
                                  wd.removeWaitDialog();
                                  UserAuthBloc().authenticate();
                                } catch (e) {
                                  print(e.message);
                                  wd.removeWaitDialog();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
