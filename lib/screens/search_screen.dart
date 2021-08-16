import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:milesrank_app/services/sailor_item.dart';
import 'package:milesrank_app/services/search.dart';
import 'package:milesrank_app/services/searched_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const historyLength = 5;
  List<String> _searchHistory = [];
  int pageNumber = 1;
  int totalPages = 1;
  List<SearchedItem> items = [];
  bool allLoaded = false;

  List<String> filteredSearchHistory = [];

  String selectedTerm = '';

  List<String> filterSearchTerms({required String filter}) {
    if (filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void fetchData(String query) async {
    if (allLoaded || (pageNumber > totalPages)) {
      return;
    }

    if (pageNumber == 1) {
      SearchModel searchModel = SearchModel();
      var searchedData = await searchModel.getSearchDataFromDBNoPageNo(query);
      List<SearchedItem> newList = copyJsonToList(await searchedData);
      if (newList.isNotEmpty) {
        items.addAll(newList);
      }
      pageNumber++;
      fetchData(query);
    } else {
      SearchModel searchModel = SearchModel();
      var searchedData =
          await searchModel.getSearchDataFromDB(pageNumber, query);
      List<SearchedItem> newList = copyJsonToList(await searchedData);
      if (newList.isNotEmpty) {
        items.addAll(newList);
      }
      pageNumber++;
      fetchData(query);
    }
  }

  List<SearchedItem> copyJsonToList(dynamic sData) {
    List<SearchedItem> newList = [];
    totalPages = sData['totalPagesCount'];
    int jsonLength = 10;

    if (pageNumber == totalPages) {
      int totalItems = sData['totalPagesCount'];
      jsonLength = totalItems % jsonLength;
    }

    for (int i = 0; i < jsonLength; i++) {
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
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            sItems: items,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm == '' ? 'Zacznij szukać...' : selectedTerm,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Wyszukaj żeglarza...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
            fetchData(query);
          });
          controller.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
                color: Color(0xFF035397),
                elevation: 4,
                child: Builder(
                  builder: (context) {
                    if (filteredSearchHistory.isEmpty &&
                        controller.query.isEmpty) {
                      return Container(
                        height: 56,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Zacznij szukać',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    } else if (filteredSearchHistory.isEmpty) {
                      return ListTile(
                        title: Text(controller.query),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          setState(() {
                            addSearchTerm(controller.query);
                            selectedTerm = controller.query;
                          });
                          controller.close();
                        },
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredSearchHistory
                            .map((term) => ListTile(
                                  title: Text(
                                    term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: const Icon(Icons.history),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        deleteSearchTerm(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      putSearchTermFirst(term);
                                      selectedTerm = term;
                                    });
                                    controller.close();
                                  },
                                ))
                            .toList(),
                      );
                    }
                  },
                )),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final List<SearchedItem> sItems;

  const SearchResultsListView({
    Key? key,
    required this.sItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Wyszukaj żeglarza',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context)!.style;

    return ListView(
      padding: EdgeInsets.only(top: fsb.height + fsb.margins.vertical),
      children: List.generate(
        sItems.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          child: Card(
            elevation: 5.0,
            child: ListTile(
              onTap: () {},
              leading: Text(sItems[index].rank.toString()),
              title: Text(
                  '${sItems[index].sailor.firstName}  ${sItems[index].sailor.lastName}'),
              subtitle: Text('mile: ${sItems[index].miles}'),
            ),
          ),
        ),
      ),
    );
  }
}
