import 'package:brew_crew/models/customuser.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyDM8tp76jdKgupSNPLr-Rvrv1VNZoqkE2k",
      appId: "XXX",
      messagingSenderId: "XXX",
      projectId: "brew-crew-3a6cf",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(home: Wrapper()));
  }
}
