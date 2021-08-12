import 'package:flutter/material.dart';
import 'package:milesrank_app/services/cruises.dart';
import 'package:milesrank_app/services/cruises_item.dart';
import 'package:milesrank_app/services/sailor_item.dart';

class SailorsScreen extends StatefulWidget {
  const SailorsScreen({Key? key}) : super(key: key);

  @override
  _SailorsScreenState createState() => _SailorsScreenState();
}

class _SailorsScreenState extends State<SailorsScreen> {
  List<CruisesItem> items = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });

    CruisesModel cruisesModel = CruisesModel();
    var cruisesData = await cruisesModel.getCruisesModelFromDB();
    items = copyJsonToList(cruisesData);

    setState(() {
      loading = false;
    });
  }

  List<CruisesItem> copyJsonToList(dynamic cData) {
    List data = cData['cruises'];
    List<CruisesItem> newList = [];
    for (int i = 0; i < data.length; i++) {
      newList.add(CruisesItem(
        id: data[i]['id'],
        name: data[i]['name'],
        startDate: DateTime.parse(data[i]['startDate']),
        endDate: DateTime.parse(data[i]['endDate']),
        yachtId: data[i]['yachtId'],
        yachtName: data[i]['yachtName'],
        captain: SailorItem(
          id: data[i]['captain']['id'],
          firstName: data[i]['captain']['firstName'],
          lastName: data[i]['captain']['lastName'],
        ),
        crew: getCrewList(data[i]['crew']),
        cruiseMiles: data[i]['cruiseMiles'],
      ));
    }
    return newList;
  }

  List<SailorItem> getCrewList(List cList) {
    List<SailorItem> crewList = [];
    for (int i = 0; i < cList.length; i++) {
      crewList.add(SailorItem(
          id: cList[i]['id'],
          firstName: cList[i]['firstName'],
          lastName: cList[i]['lastName']));
    }

    return crewList;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (items.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Rejsy'),
            centerTitle: true,
            elevation: 0,
          ),
          body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${items[index].name}'),
                              Text('${items[index].yachtName}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  'start: ${items[index].startDate.day}.${items[index].startDate.month}.${items[index].startDate.year}'),
                              Text(
                                  'koniec: ${items[index].endDate.day}.${items[index].endDate.month}.${items[index].endDate.year}'),
                              Text('mile: ${items[index].cruiseMiles}'),
                            ],
                          ),
                          Text(
                              'kpt. ${items[index].captain.firstName} ${items[index].captain.lastName}'),
                          Text('Załoga:'),
                          ListView.builder(
                            itemBuilder: (context, z) {
                              return ListTile(
                                title: Text(
                                    '${items[index].crew[z].firstName} ${items[index].crew[z].lastName}'),
                              );
                            },
                            itemCount: items[index].crew.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                          )
                        ],
                      ),
                    ));
              }),
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

