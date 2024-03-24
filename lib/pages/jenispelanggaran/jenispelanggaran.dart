import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/config/constants.dart';
import 'package:magangsipatuh/model/jenispelanggaranmodel.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JenisPelanggaran extends StatefulWidget {
  const JenisPelanggaran({super.key});

  @override
  State<JenisPelanggaran> createState() => _JenisPelanggaranState();
}



class _JenisPelanggaranState extends State<JenisPelanggaran> {
  final TextEditingController searchController = TextEditingController();
  List<JenisPelanggaranData> searchData = [];
  Widget loadingListView = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    fetchDataJenisPelanggaran("");
  }

  void fetchDataJenisPelanggaran(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';
    
    setState(() {
      loadingListView = const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      final dynamic apiUrl = Uri.parse(Constants.baseUrl + Constants.jenispelanggaranapi+'$query');
      final response = await http.get(
        apiUrl,
        headers: {
          'Cookie': token,
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          List<JenisPelanggaranData> newDataList =
              decodedData.map((item) => JenisPelanggaranData.fromJson(item)).toList();
          if (mounted) {
            setState(() {
              searchData = newDataList;
              if (newDataList.isEmpty) {
                Get.snackbar(
                  'Kosong',
                  "Data Kelas tersebut tidak ada",
                  colorText: Colors.white,
                  backgroundColor: Colors.orange,
                  icon: const Icon(Icons.add_alert),
                );
                loadingListView = ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      color: const Color(0xff3b57e6),
                      shadowColor: const Color(0x4d939393),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Kelas tidak ditemukan",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xffffffff),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffffffff),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                loadingListView = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    
                    // searchData.sort((a, b) => a.nama.compareTo(b.nama));

                    return GestureDetector(
                      onTap: () {
                        //On Tap
                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        color: const Color(0xff3b57e6),
                        shadowColor: const Color(0x4d939393),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        searchData[index].nama,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4, 0, 0),
                                        child: Text(
                                          "Poin : " +searchData[index].poin.toString(),
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffffffff),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: searchData.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                );
              }
            });
          }
        } else {
          Get.snackbar(
            'Gagal mencari data',
            "Invalid Data Format",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert),
          );
        }
      } else {
        Get.snackbar(
          'Gagal mencari data',
          "Error ${response.reasonPhrase}",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle the specific error condition here
        // You can add custom handling logic for this case
        Get.snackbar(
          'Gagal meload data',
          "Error:{$e} Connection closed before full header was received",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3b58ec),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Daftar Jenis Pelanggaran",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 22,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(const DashboardPages());
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  //Get.to(SiswaTambah());
                },
                child: Icon(
                  Icons.add_circle,
                  color: Color(0xffffffff),
                  size: 24,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: TextField(
                  controller: searchController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  onSubmitted: (value) {
                    var query = searchController.text;
                    fetchDataJenisPelanggaran(query);
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    hintText: "Pencarian",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xffabb0c4),
                    ),
                    filled: true,
                    fillColor: const Color(0xffeef1f5),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                      ),
                      onPressed: () {
                        var query = searchController.text;
                        fetchDataJenisPelanggaran(query);
                      },
                      color: const Color(0xffa9aec2),
                    ),
                  ),
                ),
              ),
              loadingListView,
              // ListView(
              //   scrollDirection: Axis.vertical,
              //   padding: const EdgeInsets.all(0),
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     Card(
              //       margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              //       color: const Color(0xff3b57e6),
              //       shadowColor: const Color(0x4d939393),
              //       elevation: 1,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         side:
              //             const BorderSide(color: Color(0x4d9e9e9e), width: 1),
              //       ),
              //       child: const Padding(
              //         padding: EdgeInsets.all(7),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.max,
              //           children: [
              //             Icon(
              //               Icons.person,
              //               color: Color(0xffffffff),
              //               size: 24,
              //             ),
              //             Expanded(
              //               flex: 1,
              //               child: Padding(
              //                 padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       "Ahmad Fauzan Arif",
              //                       textAlign: TextAlign.start,
              //                       maxLines: 1,
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.w500,
              //                         fontStyle: FontStyle.normal,
              //                         fontSize: 16,
              //                         color: Color(0xffffffff),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              //                       child: Text(
              //                         "098888288811",
              //                         textAlign: TextAlign.start,
              //                         maxLines: 1,
              //                         overflow: TextOverflow.ellipsis,
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.w400,
              //                           fontStyle: FontStyle.normal,
              //                           fontSize: 14,
              //                           color: Color(0xffffffff),
              //                         ),
              //                       ),
              //                     ),
              //                     Text(
              //                       "Pasuruan",
              //                       textAlign: TextAlign.start,
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.w400,
              //                         fontStyle: FontStyle.normal,
              //                         fontSize: 12,
              //                         color: Color(0xffffffff),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               color: Color(0xffffffff),
              //               size: 24,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      
    );
  }
}