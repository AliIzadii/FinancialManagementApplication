import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:financial_management_app/models/money.dart';
import 'package:financial_management_app/screens/home_screen.dart';
import 'package:financial_management_app/screens/main_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  await Hive.openBox<Money>('moneyBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void getData(){
    homeScreen.moneys.clear();
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    hiveBox.values.forEach((value) {
      homeScreen.moneys.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیریت مالی',
      theme: ThemeData(fontFamily: 'Iranian Sans'),
      home: mainScreen(),
      
    );
  }
}
