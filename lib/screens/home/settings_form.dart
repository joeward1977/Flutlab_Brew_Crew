import 'package:brew_crew/models/customuser.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  String _currentName = "";
  String _currentSugars = "1";
  int _currentStrength = 0;

  @override
  Widget build(BuildContext context) {
    CustomUser user = Provider.of<CustomUser>(context);
    print(_currentStrength);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return userData != null
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Update your brew settings.',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: userData.name,
                          decoration: textInputDecoration,
                          validator: (val) =>
                              val!.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) =>
                              setState(() => _currentName = val),
                        ),
                        SizedBox(height: 10.0),
                        DropdownButtonFormField(
                          value: _currentSugars.length > 0
                              ? _currentSugars
                              : userData.sugars[0],
                          decoration: textInputDecoration,
                          items: sugars.map((sugar) {
                            return DropdownMenuItem(
                              value: sugar,
                              child: Text('$sugar sugars'),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _currentSugars = val.toString()),
                        ),
                        SizedBox(height: 10.0),
                        Slider(
                          value: (_currentStrength == 0
                                  ? userData.strength
                                  : _currentStrength)
                              .toDouble(),
                          activeColor: Colors.brown[_currentStrength == 0
                              ? userData.strength
                              : _currentStrength],
                          inactiveColor: Colors.brown[_currentStrength == 0
                              ? userData.strength
                              : _currentStrength],
                          min: 100.0,
                          max: 900.0,
                          divisions: 8,
                          onChanged: (val) =>
                              setState(() => _currentStrength = val.round()),
                        ),
                        RaisedButton(
                            color: Colors.pink[400],
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                        _currentSugars != ""
                                            ? _currentSugars
                                            : userData.sugars,
                                        _currentName != ""
                                            ? _currentName
                                            : userData.name,
                                        _currentStrength != 0
                                            ? _currentStrength
                                            : userData.strength);
                                Navigator.pop(context);
                              }
                            }),
                      ],
                    ),
                  )
                : Text("No User Data");
          } else {
            return Loading();
          }
        });
  }
}
