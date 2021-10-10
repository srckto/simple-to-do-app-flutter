import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_to_do_app/database/DbHelper.dart';
import 'package:simple_to_do_app/screens/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.createDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple To Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeLayout(),
    );
  }
}
