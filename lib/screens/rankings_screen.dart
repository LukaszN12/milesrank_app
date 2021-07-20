import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milesrank_app/services/ranking_item.dart';

class RankingsScreen extends StatefulWidget {
  final rankingData;

  RankingsScreen({this.rankingData});

  @override
  _RankingsScreenState createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  List<RankingItem> rankingList = [];
  List<String> sList = [];

  @override
  void initState() {
    super.initState();
    getRankingList(widget.rankingData);
  }

  void getRankingList(dynamic rData) {
    for (int i = 0; i < 10; i++) {
      rankingList.add(RankingItem(
          rank: rData['items'][i]['rank'],
          firstName: rData['items'][i]['person']['firstName'],
          lastName: rData['items'][i]['person']['lastName'],
          change: rData['items'][i]['change'],
          id: rData['items'][i]['person']['id'],
          miles: rData['items'][i]['miles'],
          debut: rData['items'][i]['debut']));
    }
    // for (int i = 0; i < rankingList.length; i++) {
    //   print(rankingList[i].lastName);
    // }

    // print(rData['items'][0]['person']['firstName']);
    // sList.add(rData['items'][0]['person']['firstName']);
    // print(sList[0]);
  }

  //items[0].debut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: rankingList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {},
                leading: Text(rankingList[index].rank.toString()),
                title: Text(
                    '${rankingList[index].firstName} ${rankingList[index].lastName}'),
                subtitle: Text('miles: ${rankingList[index].miles}'),
              ),
            );
          }),
    );
  }
}
