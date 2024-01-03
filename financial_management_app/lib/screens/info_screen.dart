import 'package:flutter/material.dart';
import 'package:financial_management_app/chart/chart.dart';
import 'package:financial_management_app/utils/calculate.dart';

class infoScreen extends StatefulWidget {
  const infoScreen({super.key});

  @override
  State<infoScreen> createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15),
                child: Text(
                  'مدیریت تراکنش ها به تومان',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              moneyInfo(
                firstText: ' : دریافتی امروز',
                firstPrice: Calculate.todayReceive().toString(),
                secondText: ' : پرداختی امروز',
                secondPrice: Calculate.todayPay().toString(),
              ),
              moneyInfo(
                firstText: ' : دریافتی این ماه',
                firstPrice: Calculate.monthReceive().toString(),
                secondText: ' : پرداختی این ماه',
                secondPrice: Calculate.monthPay().toString(),
              ),
              moneyInfo(
                firstText: ' : دریافتی امسال',
                firstPrice: Calculate.yearReceive().toString(),
                secondText: ' : پرداختی امسال',
                secondPrice: Calculate.yearPay().toString(),
              ),
              SizedBox(height: 30),
              Calculate.yearPay() == 0 && Calculate.yearReceive == 0
                  ? Container()
                  : Container(
                      margin: EdgeInsets.all(20),
                      height: 450,
                      child: BarChartWidget(),
                    ),
            ]),
          ),
        ),
      ),
    );
  }
}

//! Money Info Widget
class moneyInfo extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  const moneyInfo({
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 13),
          )),
          Text(secondText,
              textAlign: TextAlign.right, style: TextStyle(fontSize: 13)),
          Expanded(
              child: Text(firstPrice,
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 13))),
          Text(firstText, style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
