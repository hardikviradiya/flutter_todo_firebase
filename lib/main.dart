import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_firebase/page/home_page.dart';
import 'package:flutter_todo_firebase/provider/todos.dart';
import 'package:flutter_todo_firebase/utils/shared_preference_helper.dart';
import 'package:flutter_todo_firebase/utils/utils.dart';
import 'package:provider/provider.dart';

import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'model/User.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on Exception catch (e) {
    print(e.toString());
  }
  SharedPreferenceHelper().initialize();
  // Check if the user is already registered
  String deviceId = await Utils().getDeviceId();
  User? user = await FirebaseApi().getUserDetails(deviceId);

  if(user == null){
    await FirebaseApi().storeUserDetails(deviceId);
  }

  runApp(MyApp(userId: deviceId));
}

class MyApp extends StatelessWidget {
  static final String title = 'Todo App With Firebase';
  final String userId;

  const MyApp({required this.userId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TodosProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
            primaryColor: Colors.pink,
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Color(0xFFf6f5ee),
          ),
          home: HomePage(),
        ),
      );
}
