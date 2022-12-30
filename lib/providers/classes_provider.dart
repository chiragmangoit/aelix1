import 'dart:convert';

import 'package:aelix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Classes with ChangeNotifier {
  var classesData = [];

  fetchClasses() async {
    String url = "https://api-aelix.mangoitsol.com/api/getClass";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    classesData = decodedData['data'];
    notifyListeners();
  }

  get allClass {
    return classesData;
  }

  updateClass(id, data) async {
    String url = "https://api-aelix.mangoitsol.com/api/updateClass/$id";
    var token = await Auth.token;
    final response = await http.put(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    classesData[classesData.indexWhere((element) => element['_id'] == id)]
        ['className'] = data['className'];
    print(response.body);
    notifyListeners();
    return response.statusCode;
  }

  assignClass(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/updateManyRecords";
    var token = await Auth.token;
    final response = await http.put(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
          'Content-type': 'application/json'
        },
        body: data);
    notifyListeners();
    return response.statusCode;
  }

  addClassToDatabase(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/createClass";
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    print(decodedData);
    notifyListeners();
    return decodedData;
  }

  addClass(classType) {
    classesData = classType;
    notifyListeners();
  }
}
