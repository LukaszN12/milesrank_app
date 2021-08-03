import 'package:milesrank_app/services/networking.dart';

class CruisesModel {
  Future<dynamic> getCruisesModelFromDB() async {
    var url = 'https://milesrank-staging.herokuapp.com/api/cruises';
    NetworkHelper networkHelper = NetworkHelper(url);
    var cruisesData = await networkHelper.getData();
    return cruisesData;
  }
}
