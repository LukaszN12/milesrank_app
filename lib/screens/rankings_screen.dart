import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milesrank_app/services/ranking_item.dart';
import 'package:milesrank_app/services/rankings.dart';

class RankingsScreen extends StatefulWidget {
  final rankingData;

  RankingsScreen({this.rankingData});

  @override
  _RankingsScreenState createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  final ScrollController _scrollController = ScrollController();
  int jsonLength = 10;
  int totalPages = 0;
  int pageNumber = 1;
  List<RankingItem> rankingList = [];
  bool loading = false, allLoaded = false;

  @override
  void initState() {
    super.initState();
    getRankingList(widget.rankingData, rankingList);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        pageNumber++;
        fetchRankingData(pageNumber);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  fetchRankingData(int pageNumber) async {
    if (pageNumber > totalPages) {
      return;
    }
    setState(() {
      loading = true;
    });
    List<RankingItem> newData = [];
    RankingsModel rankingsModel = RankingsModel();
    var rankingsData = await rankingsModel.getRankingsDataFromDB(pageNumber);
    getRankingList(rankingsData, newData);
    if (newData.isNotEmpty) {
      rankingList.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  void getRankingList(dynamic rData, List list) {
    totalPages = rData['totalPagesCount'];

    if (pageNumber == totalPages) {
      int totalItems = rData['totalItems'];
      jsonLength = totalItems % jsonLength;
    }
    for (int i = 0; i < jsonLength; i++) {
      list.add(RankingItem(
          rank: rData['items'][i]['rank'],
          firstName: rData['items'][i]['person']['firstName'],
          lastName: rData['items'][i]['person']['lastName'],
          change: rData['items'][i]['change'],
          id: rData['items'][i]['person']['id'],
          miles: rData['items'][i]['miles'],
          debut: rData['items'][i]['debut']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: rankingList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              child: Card(
                elevation: 5.0,
                child: ListTile(
                  onTap: () {},
                  leading: Text(rankingList[index].rank.toString()),
                  title: Text(
                      '${rankingList[index].firstName} ${rankingList[index].lastName}'),
                  subtitle: Text('miles: ${rankingList[index].miles}'),
                ),
              ),
            );
          }),
    );
  }
}
