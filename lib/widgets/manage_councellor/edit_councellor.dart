import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../providers/auth_provider.dart';
import '../../providers/counsellor_provider.dart';

class EditCounsellor extends StatefulWidget {
  const EditCounsellor({Key? key}) : super(key: key);

  @override
  State<EditCounsellor> createState() => _EditCounsellorState();
}

class _EditCounsellorState extends State<EditCounsellor> {
  var _isInit = true;
  var filterOptions;
  var selectedFilter = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClasses();
  }

  fetchClasses() async {
    String url = "https://api-aelix.mangoitsol.com/api/getClass";
    var token = await Auth.token;
    final response = await http.get(Uri.parse(url), headers: {
      'authorization': 'Bearer $token',
    });
    final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    List classes = ['All'];
    for (var data in decodedData['data']) {
      classes.add(data['className'].toString());
    }
    setState(() {
      filterOptions = classes;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Counsellor>(context).fetchCounsellors();
    }
    _isInit = false;
  }

  deleteCounsellor(id) async {
    var result = await Provider.of<Counsellor>(context, listen: false)
        .deleteCounsellors(id);
    if (!mounted) return;
    if (result == 201) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "counsellor deleted successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Counsellor>(context).counsellors != null) {
      var counsellorData = Provider.of<Counsellor>(context)
          .counsellors
          .where((council) => council['role']['name'] == "counsellor");
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ImageIcon(
                  AssetImage('assets/images/councellor.png'),size: 36,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Counsellor',
                  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(0, 92, 179, 1)),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'FILTER BY:',
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(19, 15, 38, 1)
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: DropdownButton(
                        underline: const SizedBox(),
                        menuMaxHeight:
                        MediaQuery.of(context).size.height * 0.25,
                        value: selectedFilter,
                        focusColor: Colors.black,
                        isExpanded: true,
                        iconSize: 30.0,
                        style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(19, 15, 38, 1)
                        ),
                        items: filterOptions?.map<DropdownMenuItem<String>>(
                              (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                                () {
                              selectedFilter = val!;
                            },
                          );
                          Provider.of<Counsellor>(context, listen: false)
                              .filterCounsellorByClass(val);
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 92, 179, 1)
                  ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/addCounsellor');
                    },
                    child: Text(
                      'Add Counsellor',
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(
                              255, 255, 255, 1)),
                    )),
              ],
            ),
            Column(
                children: counsellorData
                    .map<Widget>((data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] + ' ' + data['lastname'],
                                      style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                              25, 40, 56, 1)),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          data['classId']['className'],
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromRGBO(
                                                  119, 119, 119, 1)),
                                        ),
                                        const Text(' | '),
                                        Text(
                                          'Assign Students: ${data['studentCount']}',
                                          style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromRGBO(
                                                  0, 92, 179, 1)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/addCounsellor',
                                            arguments: data);
                                      },
                                      icon: const Icon(Icons.edit_note),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteCounsellor(data['_id']);
                                      },
                                      icon: const Icon(
                                          Icons.delete_forever_outlined),
                                    )
                                  ],
                                )
                              ]),
                        ))
                    .toList())
          ],
        ),
      ));
    } else {
      return const CircularProgressIndicator().centered();
    }
  }
}
