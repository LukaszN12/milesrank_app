import 'package:milesrank_app/services/networking.dart';

class RankingsModel {
  Future<dynamic> getRankingsDataFromDB() async {
    var url = 'https://milesrank.herokuapp.com/api/rankings/simple#';
    NetworkHelper networkHelper = NetworkHelper(url);
    var rankingsData = await networkHelper.getData();
    // print(rankingsData);
    return rankingsData;
  }
}
