import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:milesrank_app/screens/rankings_screen.dart';
import 'package:milesrank_app/services/rankings.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getRankingsData();
  }

  void getRankingsData() async {
    RankingsModel rankingsModel = RankingsModel();
    var rankingsData = await rankingsModel.getRankingsDataFromDB(1);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return RankingsScreen(
          rankingData: rankingsData,
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
