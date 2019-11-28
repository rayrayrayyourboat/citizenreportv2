import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(CitizenReport());
class CitizenReport extends StatefulWidget {
  @override
  _CitizenReportState createState() => _CitizenReportState();
}

class _CitizenReportState extends State<CitizenReport> {

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return MaterialApp(
    home: Home()
    );
  }

}
