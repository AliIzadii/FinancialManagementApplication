import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../models/money.dart';

String year = Jalali.now().year.toString();
String month = Jalali.now().month.toString().length == 1
    ? '0${Jalali.now().month}'
    : Jalali.now().month.toString();
String day = Jalali.now().day.toString().length == 1
    ? '0${Jalali.now().day}'
    : Jalali.now().day.toString();
Box<Money> hiveBox = Hive.box<Money>('moneyBox');

class Calculate {
  static String todayDate() {
    return year + '/' + month + '/' + day;
  }

  static double todayPay() {
    double result = 0;
    for (var value in hiveBox.values) {
      if (value.date == todayDate() && value.isResieve == false) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double todayReceive() {
    double result = 0;
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      if (value.date == todayDate() && value.isResieve == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double monthPay() {
    double result = 0;
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isResieve == false) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double monthReceive() {
    double result = 0;
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isResieve == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double yearPay() {
    double result = 0;
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isResieve == false) {
        result += double.parse(value.price);
      }
    }
    return result;
  }

  static double yearReceive() {
    double result = 0;
    Box<Money> hiveBox = Hive.box<Money>('moneyBox');
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isResieve == true) {
        result += double.parse(value.price);
      }
    }
    return result;
  }
}
