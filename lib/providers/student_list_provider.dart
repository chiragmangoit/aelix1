import 'dart:convert';

import 'package:aelix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/common_model.dart';

class StudentList with ChangeNotifier {
  var studentData;
  var allStudent;
  String? classT = 'All';

  fetchStudent(url) async {
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    allStudent = decodedData['data'];
    studentData = decodedData['data'];
    CommonModel.studentList = studentData;
    notifyListeners();
  }

  deleteStudent(id) async {
    var data = jsonEncode({"id": id});
    String url = "https://api-aelix.mangoitsol.com/api/deleteStudent";
    var token = await Auth.token;
    final response = await http.delete(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
          'Content-type': 'application/json'
        },
        body: data);
    final catalogJson = response.body;
    print(catalogJson);
    for (var ids in id) {
      studentData.removeWhere((item) => item['_id'] == ids);
    }
    notifyListeners();
    return response.statusCode;
  }

  dismissStudent(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/dismiss";
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
          'Content-type': 'application/json'
        },
        body: data);
    notifyListeners();
    return response.statusCode;
  }

  addStudent(data, imageFile) async {
    var token = await Auth.token;
    String? url = "https://api-aelix.mangoitsol.com/api/createStudent";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    if (imageFile != null) {
      var filepath = imageFile!.path;
      request.files.add(await http.MultipartFile.fromPath('image', filepath));
    }
    request.headers['authorization'] = 'Bearer $token';
    data.forEach((key, value) {
      if (key != 'Ename' && key != 'number') {
        request.fields[key] = "$value";
      }
    });
    var res = await request.send();
    // res = request
    //     .send()
    //     .then((result) async { return
    //       http.Response.fromStream(result).then((response) {
    //         print('response.body ${response.body}');
    //         return response.body;
    //       });
    //     })
    //     .catchError((err) => print('error : $err'))
    //     .whenComplete(() {});
    return res.statusCode;
  }

  updateStudent(data, imageFile, id) async {
    var token = await Auth.token;
    String? url = "https://api-aelix.mangoitsol.com/api/updateStudent/$id";
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    if (imageFile != null) {
      var filepath = imageFile!.path;
      request.files.add(await http.MultipartFile.fromPath('image', filepath));
    }
    request.headers['authorization'] = 'Bearer $token';
    data.forEach((key, value) {
      if (key != 'Ename' &&
          key != 'number' &&
          key != 'dismiss' &&
          key != 'attaindence' &&
          key != 'classId' &&
          key != 'createdAt' &&
          key != 'updatedAt' &&
          key != '__v' &&
          key != 'image' &&  key != '_id') {
        request.fields[key] = "$value";
      }
    });
    var res = await request.send();
    notifyListeners();
    http.Response.fromStream(res).then((value) => print(value.body));
    return res.statusCode;
  }

  uploadCsv(data) async {
    String url = "https://api-aelix.mangoitsol.com/api/uploadcsv";
    var token = await Auth.token;
    final response = await http.post(Uri.parse(url),
        headers: {
          'authorization': 'Bearer $token',
          'Content-type': 'application/json'
        },
        body: data);
    notifyListeners();
    return response.statusCode;
  }

  get data {
    return studentData;
  }

  get allStudentData {
    studentData = allStudent;
    notifyListeners();
  }

  get absentStudent {
    var absentStudent = studentData
        .where((student) =>
            student['attaindence']['attendence'] == null ||
            student['attaindence']['attendence'] == '0')
        .toList();
    return absentStudent;
  }

  get presentStudent {
    var pStudent = studentData
        .where((student) => student['attaindence']['attendence'] == '1')
        .toList();
    return pStudent;
  }

  get outOfClassStudennt {
    var outStudent = studentData
        .where((student) =>
            student['attaindence']['out_of_class'] != 'No' &&
            student['attaindence']['out_of_class'] != null)
        .toList();
    return outStudent;
  }

  get classType {
    return classT;
  }

  set classValue(value) {
    classT = value;
  }

  filterStudentByClass(classType) {
    classT = classType;
    studentData = allStudent
        .where((data) => data['assignClass']['className'] == classType)
        .toList();
    notifyListeners();
  }

  updateStudentList(id, updatedAttendanceData) {
    studentData[studentData.indexWhere((element) => element['_id'] == id)]
        ['attaindence'] = updatedAttendanceData;
    notifyListeners();
  }
}
