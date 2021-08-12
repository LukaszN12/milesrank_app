import 'package:milesrank_app/services/networking.dart';

class SearchModel {
  Future<dynamic> getSearchDataFromDB(int pageNo, String query) async {
    var url =
        'https://milesrank-staging.herokuapp.com/api/rankings/simple?pageNo=$pageNo&pageSize=10&query=$query';
    NetworkHelper networkHelper = NetworkHelper(url);
    var searchData = await networkHelper.getData();
    return searchData;
  }
}
