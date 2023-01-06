import 'dart:convert';
import 'dart:io';

import 'package:aelix/widgets/profile/profile_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/auth_provider.dart';
import 'textWidget.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  var userData = {};
  var country = [];
  var stateList = [];
  var selectedCountry;
  var selectedState;
  var id;
  bool editMode = true;
  bool isChange = false;
  final _formKey = GlobalKey<FormState>();

  // String? token = '';
  PickedFile? _imageFile;
  final String uploadUrl = 'http://103.127.29.85:5001/api/createNews';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadCountry();
    loadState();
  }

  loadUserData() async {
    var loggedUser = await Auth.user;
    id = loggedUser['_id'];
    var url = "https://api-aelix.mangoitsol.com/api/user/$id";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var user = decodedData['data'][0];
    setState(() {
      userData = user;
      selectedCountry = userData['country'];
      selectedState = userData['state'];
    });
  }

  loadCountry() async {
    var url = "https://api-aelix.mangoitsol.com/api/getAllCountry";
    final response = await http.get(Uri.parse(url));
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var countries = decodedData['country'];
    setState(() {
      country = countries;
    });
  }

  loadState() async {
    var url =
        "https://api-aelix.mangoitsol.com/api/state/62c3ddf4211090cd519f550a";
    final response = await http.get(Uri.parse(url));
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var states = decodedData;
    setState(() {
      stateList = states;
    });
  }

  Future<String?> uploadData(data) async {
    var token = await Auth.token;
    String? url = "https://api-aelix.mangoitsol.com/api/updateUser/$id";
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    if (_imageFile != null) {
      var filepath = _imageFile!.path;
      request.files.add(await http.MultipartFile.fromPath('image', filepath));
    }
    request.headers['authorization'] = 'Bearer $token';
    data.forEach((key, value) {
      request.fields[key] = "$value";
    });
    // var res = await request.send();
    // print(res.reasonPhrase);
    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            print('response.body ${response.body}');
            return response.body;
          });
        })
        .catchError((err) => print('error : $err'))
        .whenComplete(() {
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            message: "data updated",
            duration: const Duration(seconds: 3),
            leftBarIndicatorColor: Colors.green,
          ).show(context).then((value) => Navigator.pop(context));
        });
    if (!mounted) return null;
    // return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ${response.exception!.code}');
    }
  }

  void _pickImage() async {
    setState(() {
      isChange = true;
    });
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      if (File(pickedFile!.path).lengthSync() < 6000) {
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        if (!mounted) return;
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          message: "image should be below 6kb",
          duration: const Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red,
        ).show(context);
      }
    } catch (e) {
      print("Image picker error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map newUserData;
    return userData.isNotEmpty
        ? Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileWidget(
                      imagePath: _imageFile != null
                          ? _imageFile!.path
                          : "https://api-aelix.mangoitsol.com/${userData['image']}",
                      isEdit: true,
                      onClicked: _pickImage,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['name'],
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(19, 15, 38, 1)),
                        ),
                        Text(
                          Auth.role.toString().upperCamelCase,
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(19, 15, 38, 1)),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            editMode = false;
                          });
                        },
                        icon: const Icon(
                          Icons.edit_note_sharp,
                          size: 28,
                        ))
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'My Address',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  mode: editMode,
                  label: 'Street Address',
                  text: userData['street_Address'],
                  onChanged: (address) {
                    setState(() {
                      isChange = true;
                    });
                    userData['street_Address'] = address;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Country',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 7),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                  value: selectedCountry,
                  focusColor: Colors.black,
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(color: Colors.black),
                  items: country.map<DropdownMenuItem<String>>(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val['_id'],
                        child: Text(val['name']),
                      );
                    },
                  ).toList(),
                  onChanged: editMode ? null : (val) {
                    setState(
                      () {
                        isChange = true;
                        selectedCountry = val!;
                        userData['country'] = val!;
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'State',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 7),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter value';
                    }
                    return null;
                  },
                  value: selectedState,
                  focusColor: Colors.black,
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(color: Colors.black),
                  items: stateList.map<DropdownMenuItem<String>>(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val['_id'],
                        child: Text(val['name']),
                      );
                    },
                  ).toList(),
                  onChanged: editMode ? null :  (val) {
                    setState(
                      () {
                        isChange = true;
                        selectedState = val!;
                        userData['state'] = val!;
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  mode: editMode,
                  label: 'City',
                  text: userData['city'],
                  onChanged: (city) {
                    setState(() {
                      isChange = true;
                    });
                    userData['city'] = city;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Contact Detail',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  mode: editMode,
                  label: 'Email',
                  text: userData['email'],
                  onChanged: (email) {
                    setState(() {
                      isChange = true;
                    });
                    userData['email'] = email;
                  },
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  mode: editMode,
                  label: 'Mobile Number',
                  text: userData['phone'].toString(),
                  onChanged: (number) {
                    setState(() {
                      isChange = true;
                    });
                    userData['phone'] = int.parse(number);
                  },
                ),
                if(!editMode)
                const SizedBox(height: 24),
                if(!editMode)
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => {
                              if (isChange)
                                {
                                  newUserData = {
                                    "role": userData['role'],
                                    "street_Address":
                                        userData["street_Address"],
                                    "mobileNumber": userData["mobileNumber"],
                                    "country": userData["country"],
                                    "city": userData["city"],
                                    "state": userData["state"],
                                    "email": userData["email"],
                                    "name": userData["name"],
                                  },
                                  setState(() {
                                    editMode = true;
                                  }),
                                  if (_formKey.currentState!.validate())
                                    {
                                      uploadData(newUserData),
                                    }
                                }
                            },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    ElevatedButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ],
            ),
          )
        : const CircularProgressIndicator().centered();
  }
}
