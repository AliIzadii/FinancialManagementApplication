import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:financial_management_app/main.dart';
import 'package:financial_management_app/models/money.dart';

class newTransactionScreen extends StatefulWidget {
  const newTransactionScreen({super.key});
  static int groupId = 0;
  static int index = 0;
  static bool isEditing = false;
  static String date = 'تاریخ';
  static TextEditingController descController = TextEditingController();
  static TextEditingController priceController = TextEditingController();

  @override
  State<newTransactionScreen> createState() => _newTransactionScreenState();
}

class _newTransactionScreenState extends State<newTransactionScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  newTransactionScreen.isEditing
                      ? 'ویرایش تراکنش'
                      : 'تراکنش جدید',
                  style: TextStyle(fontSize: 18),
                ),
                textField(
                  hintText: 'توضیحات',
                  controller: newTransactionScreen.descController,
                  errorText: 'لطفا توضیحات را بنویسید',
                ),
                SizedBox(
                  height: 5,
                ),
                textField(
                  hintText: 'مبلغ',
                  controller: newTransactionScreen.priceController,
                  errorText: 'لطفا مبلغ را وارد کنید',
                  type: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                typeAndDate(),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Money item = Money(
                          id: Random().nextInt(10000000),
                          date: newTransactionScreen.date,
                          title: newTransactionScreen.descController.text,
                          price: newTransactionScreen.priceController.text,
                          isResieve:
                              newTransactionScreen.groupId == 1 ? true : false,
                        );
                        if (newTransactionScreen.isEditing) {
                          //homeScreen.moneys[newTransactionScreen.index] = item
                          int findIndexFromId = 0;
                          MyApp.getData();
                          for (int i = 0; i < hiveBox.values.length; i++) {
                            if (hiveBox.values.elementAt(i).id ==
                                newTransactionScreen.index) {
                              findIndexFromId = i;
                            }
                          }
                          hiveBox.putAt(findIndexFromId, item);
                        } else {
                          // homeScreen.moneys.add(item)
                          hiveBox.add(item);
                        }
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(234, 169, 66, 187),
                        elevation: 0,
                      ),
                      child: newTransactionScreen.isEditing
                          ? Text('ویرایش کردن', style: TextStyle(color: Colors.black87))
                          : Text('اضافه کردن', style: TextStyle(color: Colors.black87)),
                    )),
              ],
            ),
          )),
    );
  }
}

class typeAndDate extends StatefulWidget {
  const typeAndDate({
    super.key,
  });

  @override
  State<typeAndDate> createState() => _typeAndDateState();
}

class _typeAndDateState extends State<typeAndDate> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        radioButton(
          value: 1,
          groupValue: newTransactionScreen.groupId,
          onChanged: (value) {
            setState(() {
              newTransactionScreen.groupId = value!;
            });
          },
          text: 'دریافتی',
        ),
        radioButton(
          value: 2,
          groupValue: newTransactionScreen.groupId,
          onChanged: (value) {
            setState(() {
              newTransactionScreen.groupId = value!;
            });
          },
          text: 'پرداختی',
        ),
        OutlinedButton(
          onPressed: () async {
            var pickerDate = await showPersianDatePicker(
                context: context,
                initialDate: Jalali.now(),
                firstDate: Jalali(1402),
                lastDate: Jalali(1410));
            setState(() {
              String year = pickerDate!.year.toString();
              String month = pickerDate.month.toString().length == 1
                  ? '0${pickerDate.month.toString()}'
                  : pickerDate.month.toString();
              String day = pickerDate.day.toString().length == 1
                  ? '0${pickerDate.day.toString()}'
                  : pickerDate.day.toString();

              newTransactionScreen.date = year + '/' + month + '/' + day;
            });
          },
          child: Text(
            newTransactionScreen.date,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class radioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const radioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(text)
      ],
    );
  }
}

class textField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType type;
  final String errorText;
  const textField({
    required this.hintText,
    required this.controller,
    required this.errorText,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      cursorColor: Colors.black38,
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300))),
    );
  }
}
