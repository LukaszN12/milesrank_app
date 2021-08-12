import 'package:flutter/material.dart';
import 'package:milesrank_app/services/sailor_item.dart';
import 'package:milesrank_app/services/search.dart';
import 'package:milesrank_app/services/searched_item.dart';

class SearchScreenOld extends StatefulWidget {
  const SearchScreenOld({Key? key}) : super(key: key);

  @override
  _SearchScreenOldState createState() => _SearchScreenOldState();
}

class _SearchScreenOldState extends State<SearchScreenOld> {
  final ScrollController _scrollController = ScrollController();
  List<SearchedItem> items = [];
  bool loading = false, allLoaded = false;
  int pageNumber = 1;
  int totalPages = 1;
  String query = '';

  @override
  void initState() {
    super.initState();
    fetchData(pageNumber, query);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        pageNumber++;
        fetchData(pageNumber, query);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void fetchData(int pageNumber, String query) async {
    if (allLoaded || (pageNumber > totalPages)) {
      return;
    }

    setState(() {
      loading = true;
    });

    SearchModel searchModel = SearchModel();
    var searchData = await searchModel.getSearchDataFromDB(pageNumber, query);
    List<SearchedItem> newData = copyJsonToList(searchData);
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  List<SearchedItem> copyJsonToList(dynamic sData) {
    List<SearchedItem> newList = [];
    totalPages = sData['totalPagesCount'];

    for (int i = 0; i < totalPages; i++) {
      newList.add(
        SearchedItem(
          rank: sData['items'][i]['rank'],
          sailor: SailorItem(
            id: sData['items'][i]['person']['id'],
            firstName: sData['items'][i]['person']['firstName'],
            lastName: sData['items'][i]['person']['lastName'],
          ),
          miles: sData['items'][i]['miles'],
          change: sData['items'][i]['change'],
          debut: sData['items'][i]['debut'],
        ),
      );
    }

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wyszukiwarka'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    hintText: 'Wyszukaj żeglarza',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fetchData(pageNumber, value);
                    });
                  },
                ),
              ),
              Stack(
                children: [
                  ListView.builder(
                      controller: _scrollController,
                      itemCount: items.length,
                      shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
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
                                  '${items[index].sailor.firstName}  ${items[index].sailor.lastName}'),
                              subtitle: Text('mile: ${items[index].miles}'),
                            ),
                          ),
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
