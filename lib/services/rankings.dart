import 'package:milesrank_app/services/networking.dart';

class RankingsModel {
  Future<dynamic> getRankingsDataFromDB(int pageNo) async {
    var url =
        'https://milesrank-staging.herokuapp.com/api/rankings/simple?pageNo=$pageNo&pageSize=10';
    NetworkHelper networkHelper = NetworkHelper(url);
    var rankingsData = await networkHelper.getData();
    return rankingsData;
  }
}
