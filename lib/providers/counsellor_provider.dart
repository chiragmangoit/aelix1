import 'dart:convert';

import 'package:aelix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Counsellor with ChangeNotifier {
  var counsellorData;
  var filteredData;

  fetchCounsellors() async {
    String url = "https://api-aelix.mangoitsol.com/api/getUser";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    counsellorData = decodedData;
    filteredData = decodedData;
    notifyListeners();
  }

  deleteCounsellors(id) async {
    String url = "https://api-aelix.mangoitsol.com/api/deleteUser/$id";
    var token = await Auth.token;
    final response = await http.delete(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    counsellorData.removeWhere((item) => item['_id'] == id);
    notifyListeners();
    return response.statusCode;
  }

  addCounsellor(data) async {
    String url = 'https://api-aelix.mangoitsol.com/api/createUser';
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    notifyListeners();
    return response.statusCode;
  }

  updateCounsellor(id, data) async {
    String url = 'https://api-aelix.mangoitsol.com/api/updateUser/$id';
    var token = await Auth.token;
    final response = await http.put(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: data);
    print(response.body);
    notifyListeners();
    return response.statusCode;
  }

  filterCounsellorByClass(classType) {
    if(classType != 'All') {
      counsellorData = filteredData
          .where((data) => data['classId'] != null && data['classId']['className'] == classType)
          .toList();
      notifyListeners();
    } else {
      counsellorData = filteredData;
      notifyListeners();
    }
  }


  get counsellors {
    return counsellorData;
  }
}
