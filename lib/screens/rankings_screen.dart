import 'package:flutter/material.dart';
import 'package:milesrank_app/services/ranking_item.dart';
import 'package:milesrank_app/services/rankings.dart';

class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final ScrollController _scrollController = ScrollController();
  List<RankingItem> items = [];
  bool loading = false, allLoaded = false;
  int pageNumber = 1;
  int totalPages = 1;

  void fetchData(int pageNumber) async {
    if (allLoaded || (pageNumber > totalPages)) {
      return;
    }

    setState(() {
      loading = true;
    });

    RankingsModel rankingsModel = RankingsModel();
    var rankingData = await rankingsModel.getRankingsDataFromDB(pageNumber);
    List<RankingItem> newData = copyJsonToList(rankingData);

    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  List<RankingItem> copyJsonToList(dynamic rData) {
    List<RankingItem> newList = [];
    totalPages = rData['totalPagesCount'];
    int jsonLength = 10;

    if (pageNumber == totalPages) {
      int totalItems = rData['totalItems'];
      jsonLength = totalItems % jsonLength;
    }
    for (int i = 0; i < jsonLength; i++) {
      newList.add(RankingItem(
          rank: rData['items'][i]['rank'],
          firstName: rData['items'][i]['person']['firstName'],
          lastName: rData['items'][i]['person']['lastName'],
          change: rData['items'][i]['change'],
          id: rData['items'][i]['person']['id'],
          miles: rData['items'][i]['miles'],
          debut: rData['items'][i]['debut']));
    }
    return newList;
  }

  @override
  void initState() {
    super.initState();
    fetchData(pageNumber);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        pageNumber++;
        fetchData(pageNumber);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (items.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Ranking'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Stack(children: [
            ListView.builder(
                controller: _scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 10.0),
                    child: Card(
                      elevation: 5.0,
                      child: ListTile(
                        onTap: () {},
                        leading: Text(items[index].rank.toString()),
                        title: Text(
                            '${items[index].firstName} ${items[index].lastName}'),
                        subtitle: Text('mile: ${items[index].miles}'),
                      ),
                    ),
                  );
                }),
            if (loading) ...[
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: constraints.maxWidth,
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ]
          ]),
        );
      } else {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
