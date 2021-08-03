import 'package:milesrank_app/services/sailor_item.dart';

class CruisesItem {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final int yachtId;
  final String yachtName;
  final SailorItem captain;
  final List<SailorItem> crew;
  final double cruiseMiles;

  CruisesItem(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.yachtId,
      required this.yachtName,
      required this.captain,
      required this.crew,
      required this.cruiseMiles});
}
