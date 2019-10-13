import './sem_model.dart';

class Repository {
  // http://locationsng-api.herokuapp.com/api/v1/lgas
  // test() => _nigeria.map((map) => StateModel.fromJson(map));
  List<Map> getAll() => _it;

  getLocalByState(String state) => _it
      .map((map) => StateModel.fromJson(map))
      .where((item) => item.state == state)
      .map((item) => item.lgas)
      .expand((i) => i)
      .toList();
  // _nigeria.where((list) => list['state'] == state);
  // .map((item) => item['lgas'])
  // .expand((i) => i)
  // .toList();

  List<String> getStates() => _it
      .map((map) => StateModel.fromJson(map))
      .map((item) => item.state)
      .toList();
  // _nigeria.map((item) => item['state'].toString()).toList();

  List _it = [
    {
      "state": "SEM 5",
      "alias": "adamawa",
      "lgas": [
        "ADA","JAVA","SP"
      ]
    },
    {
      "state": "SEM 6",
      "alias": "akwa_ibom",
      "lgas": [
        "SE","DCDR","WT"
      ]
    },
    
  ];
}
