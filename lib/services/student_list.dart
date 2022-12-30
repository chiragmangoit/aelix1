// import 'dart:convert';
//
// import 'package:aelix/providers/auth_provider.dart';
// import 'package:http/http.dart' as http;
//
// class StudentList {
//   static var studentData;
//
//   fetchStudent() async {
//     String url = "https://api-aelix.mangoitsol.com/api/student";
//     var token = Auth.token;
//     final response = await http.get(Uri.parse(url), headers: {
//       'authorization': 'Bearer $token',
//     });
//     final catalogJson = response.body;
//     final decodedData = jsonDecode(catalogJson);
//     studentData = decodedData;
//   }
//
//   static getStudent() {
//     var absentStudent = studentData['data']
//         .where((student) => student['attaindence']['attaindence'] == null)
//         .toList();
//     return absentStudent;
//   }
// }
