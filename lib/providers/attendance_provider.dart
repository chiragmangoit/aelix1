import 'dart:convert';

import 'package:aelix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Attendance with ChangeNotifier {

  var attendanceData;

  updateAttendance(id, attendance, endPoint) async {
    String url = 'https://api-aelix.mangoitsol.com/api/$endPoint/$id';
    var token = await Auth.token;
    final response = await http.put(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
        },
        body: attendance);
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    if( endPoint != 'updateStatus') {
      attendanceData = decodedData['attaindenceupdatedData'];
    } else {
      attendanceData = decodedData['updatestatus'];
    }
    notifyListeners();
  }


  get updatedAttendance {
    return attendanceData;
  }
}
