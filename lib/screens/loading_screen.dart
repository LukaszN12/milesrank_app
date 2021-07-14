import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:milesrank_app/screens/rankings_screen.dart';
import 'package:milesrank_app/services/sailors.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getSailorsData();
  }

  void getSailorsData() async {
    SailorsModel sailorsModel = SailorsModel();
    var sailorsData = await sailorsModel.getSailorsData();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return RankingsScreen(
          sailorsData: sailorsData,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitWave(
        color: Colors.white,
        size: 100.0,
      )),
    );
  }
}
