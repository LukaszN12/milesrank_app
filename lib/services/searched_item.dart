import 'package:milesrank_app/services/sailor_item.dart';

class SearchedItem {
  final int rank;
  final SailorItem sailor;
  final double miles;
  final int change;
  final bool debut;

  SearchedItem(
      {required this.rank,
      required this.sailor,
      required this.miles,
      required this.change,
      required this.debut});
}
