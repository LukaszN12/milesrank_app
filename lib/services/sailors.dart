import 'package:milesrank_app/services/networking.dart';

class SailorsModel {
  Future<dynamic> getSailorsData() async {
    var url = 'https://milesrank.herokuapp.com/api/rankings/simple#';
    NetworkHelper networkHelper = NetworkHelper(url);
    var sailorsData = await networkHelper.getData();
    print(sailorsData);
    return sailorsData;
  }
}
