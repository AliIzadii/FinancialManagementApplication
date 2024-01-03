import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:financial_management_app/models/money.dart';
import 'package:financial_management_app/screens/new_transaction_screen.dart';
import 'package:financial_management_app/utils/calculate.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../main.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  static List<Money> moneys = [];
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              searchBar(),
              // Expanded(child: emptyWidget()),
              Expanded(
                child: homeScreen.moneys.isEmpty
                    ? emptyWidget()
                    : ListView.builder(
                        itemCount: homeScreen.moneys.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            //! Edit
                            onTap: () {
                              newTransactionScreen.descController.text =
                                  homeScreen.moneys[index].title;
                              newTransactionScreen.priceController.text =
                                  homeScreen.moneys[index].price;
                              newTransactionScreen.groupId =
                                  homeScreen.moneys[index].isResieve ? 1 : 2;
                              newTransactionScreen.isEditing = true;
                              newTransactionScreen.index =
                                  homeScreen.moneys[index].id;
                              newTransactionScreen.date =
                                  homeScreen.moneys[index].date;
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        newTransactionScreen(),
                                  ),
                                ).then((value) {
                                  MyApp.getData();
                                  setState(() {});
                                });
                              });
                            },
                            //! Delete
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'آیا از حذف خود مطمئن هستید؟',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        'خیر',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        hiveBox.deleteAt(index);
                                        MyApp.getData();
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'بله',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: MyList(index: index),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        if ((Calculate.yearReceive() - Calculate.yearPay()) <=
                            0) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            confirmBtnText: 'باشه',
                            title: 'مانده حساب',
                            titleTextStyle: TextStyle(fontSize: 15),
                            text: ' -موجودی حساب: ' +
                                (Calculate.yearReceive() - Calculate.yearPay())
                                    .abs()
                                    .toString(),
                          );
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            confirmBtnText: 'باشه',
                            title: 'مانده حساب',
                            titleTextStyle: TextStyle(fontSize: 15),
                            text: 'موجودی حساب: ' +
                                (Calculate.yearReceive() - Calculate.yearPay())
                                    .toString(),
                          );
                        }
                      },
                      child: Icon(Icons.account_balance),
                      backgroundColor: Color.fromARGB(234, 169, 66, 187),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      elevation: 0,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        newTransactionScreen.descController.text = '';
                        newTransactionScreen.priceController.text = '';
                        newTransactionScreen.groupId = 0;
                        newTransactionScreen.isEditing = false;
                        newTransactionScreen.date = 'تاریخ';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => newTransactionScreen(),
                          ),
                        ).then((value) {
                          MyApp.getData();
                          setState(() {});
                        });
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Color.fromARGB(234, 169, 66, 187),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      elevation: 0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 15, left: 10),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              textEditingController: searchController,
              isOriginalAnimation: false,
              buttonBorderColour: Colors.black45,
              secondaryButtonWidget: Icon(Icons.close),
              buttonWidget: Icon(Icons.search),
              trailingWidget: Icon(Icons.search),
              buttonElevation: 0,
              hintText: '...جستجو کنید',
              onCollapseComplete: () {
                MyApp.getData();
                setState(() {});
                searchController.text = '';
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where((value) =>
                        value.title.contains(text) || value.date.contains(text))
                    .toList();
                homeScreen.moneys.clear();
                setState(() {
                  result.forEach((value) {
                    homeScreen.moneys.add(value);
                  });
                });
              },
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'تراکنش ها',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class MyList extends StatelessWidget {
  final int index;
  MyList({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: homeScreen.moneys[index].isResieve
                      ? Colors.green
                      : Colors.red,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                homeScreen.moneys[index].isResieve ? Icons.add : Icons.remove,
                color: Colors.white,
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                homeScreen.moneys[index].title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Container(
                      child: Row(
                    children: [
                      Text(
                        'تومان ',
                        style: TextStyle(
                            color: homeScreen.moneys[index].isResieve
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16),
                      ),
                      Text(
                        homeScreen.moneys[index].price,
                        style: TextStyle(
                            color: homeScreen.moneys[index].isResieve
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    homeScreen.moneys[index].date,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//! Empty Widget
class emptyWidget extends StatelessWidget {
  const emptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image.asset(
          'assets/images/image.png',
          width: 200,
          height: 200,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          '!تراکنشی موجود نیست',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Spacer(),
      ],
    );
  }
}
