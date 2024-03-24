import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/model/datamodel.dart';
import 'package:magangsipatuh/pages/scanqr/scanqr.dart';
import 'package:magangsipatuh/services/authservices.dart';
import 'package:magangsipatuh/widgets/appdrawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPages extends StatefulWidget {
  const DashboardPages({super.key});

  @override
  State<DashboardPages> createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TooltipBehavior _tooltipBehaviorKategori;
  late TooltipBehavior _tooltipBehaviorPelanggaranToday;
  late TooltipBehavior _tooltipBehaviorPelanggaranPerKelas;
  @override
  void initState() {
    super.initState();
    AuthService.checkLoginState();
    _tooltipBehaviorKategori = TooltipBehavior(enable: true);
    _tooltipBehaviorPelanggaranToday = TooltipBehavior(enable: true);
    _tooltipBehaviorPelanggaranPerKelas = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xff3b58ec),
        iconTheme: IconThemeData(color: Colors.white),
        /*
        actions: [
          IconButton(onPressed: (){
            _scaffoldKey.currentState?.openDrawer();
          }, icon: Icon(Icons.menu))
        ],
        leading: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20
            ),
            child: GestureDetector(
              onTap: () {
                //openDialogProfile();
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
                radius: 20,
              ),
            ),
          ),
          */

        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          'SiPatuh',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 22,
            color: Color(0xffffffff),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () {
                //openDialogProfile();
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'),
                radius: 20,
              ),
            ),
          )
        ],
      ),
      drawer: const Drawer(
        width: 278,
        child: AppDrawer(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          GridView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.6,
            ),
            children: [
              //countsiswa
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff3a57e9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder<int>(
                      future: countSiswa(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 24,
                              color: Color(0xffa5dff2),
                            ),
                          );
                        }
                      },
                    ),
                    const Text(
                      "Siswa",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
              //Count total Pelanggaran
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff3956e8),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder<int>(
                      future: countPelanggaran(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 24,
                              color: Color(0xffa4ddf0),
                            ),
                          );
                        }
                      },
                    ),
                    const Text(
                      "Pelanggaran",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff3956e9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder<int>(
                      future: countPelanggaranToday(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Text(
                            snapshot.data.toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 24,
                              color: Color(0xffa4ddf0),
                            ),
                          );
                        }
                      },
                    ),
                    const Text(
                      "Hari ini",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GridView(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.3,
            ),
            children: [
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff3956e8),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Kategori Pelanggaran",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<PelanggaranKategoriData>>(
                        future: fetchPelanggaranKategoriData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            List<PelanggaranKategoriData>
                                _pelanggaranKategoriData = snapshot.data!;

                            return SfCircularChart(
                              palette: const <Color>[
                                Colors.amber,
                                Colors.lightBlue,
                                Colors.white,
                                Colors.purple
                              ],
                              tooltipBehavior: _tooltipBehaviorKategori,
                              // legend: Legend(
                              //   isVisible: true,
                              //   overflowMode: LegendItemOverflowMode.wrap,
                              // ),
                              series: <CircularSeries>[
                                DoughnutSeries<PelanggaranKategoriData, String>(
                                  dataSource: _pelanggaranKategoriData,
                                  xValueMapper:
                                      (PelanggaranKategoriData data, _) =>
                                          data.kategori,
                                  yValueMapper:
                                      (PelanggaranKategoriData data, _) =>
                                          data.total,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                  sortingOrder: SortingOrder.descending,
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xff3956e8),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Hari Ini",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: fetchPelanggaranHariIniData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            // ignore: unrelated_type_equality_checks
                            if (snapshot.data == 0) {
                              return const Center(
                                child: Text('Tidak ada pelanggaran hari ini}'),
                              );
                            } else {
                              List<PelanggaranHariIniData> pelanggaranHariIni =
                                  snapshot.data!;
                              return SfCircularChart(
                                palette: const <Color>[
                                  Colors.amber,
                                  Colors.orange,
                                  Colors.cyan,
                                  Colors.redAccent,
                                  Colors.lightBlue,
                                  Colors.limeAccent,
                                ],

                                tooltipBehavior:
                                    _tooltipBehaviorPelanggaranToday,
                                // legend: Legend(
                                //   isVisible: true,
                                //   overflowMode: LegendItemOverflowMode.wrap,
                                // ),
                                series: <CircularSeries>[
                                  PieSeries<PelanggaranHariIniData, String>(
                                    dataSource: pelanggaranHariIni,
                                    xValueMapper:
                                        (PelanggaranHariIniData data, _) =>
                                            data.jenis,
                                    yValueMapper:
                                        (PelanggaranHariIniData data, _) =>
                                            data.total,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                    ),
                                    enableTooltip: true,
                                  )
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: GridView(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 2,
                childAspectRatio: 1.2,
              ),
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xff3a57e8),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 0,
                        ),
                        child: Text(
                          "Pelanggaran Per Kelas",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        child: FutureBuilder(
                          future: fetchPelanggaranPerKelasData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<PelanggaranPerKelasData>
                                  _pelanggaranPerKelasData = snapshot.data!;
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                legend: const Legend(
                                  isVisible: true,
                                  position: LegendPosition.bottom,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                tooltipBehavior:
                                    _tooltipBehaviorPelanggaranPerKelas,
                                series: <CartesianSeries<
                                    PelanggaranPerKelasData, String>>[
                                  ColumnSeries<PelanggaranPerKelasData, String>(
                                    name: "Kelas",
                                    dataSource: _pelanggaranPerKelasData,
                                    color: Colors.amber,
                                    xValueMapper:
                                        (PelanggaranPerKelasData data, _) =>
                                            data.kelas,
                                    yValueMapper:
                                        (PelanggaranPerKelasData data, _) =>
                                            //int.tryParse(data.total)
                                            data.total,
                                    dataLabelSettings: const DataLabelSettings(
                                      color: Colors.white,
                                      isVisible: true,
                                    ),
                                    enableTooltip: true,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff3b58ec),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.warning),
              iconSize: 34,
              color: Colors.white,
              onPressed: () => _onItemTapped(0),
            ),

            SizedBox(width: 64), // adjust the space to center
            IconButton(
              icon: Icon(Icons.person),
              iconSize: 34,
              color: Colors.white,
              onPressed: () => _onItemTapped(1),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          Get.to(() => ScanQr());
        },
        tooltip: 'ScanQr',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              50.0), // Adjust the value to make it more or less rounded
        ),
        backgroundColor: const Color(0xff3b58ec),
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
