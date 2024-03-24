import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/config/constants.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:magangsipatuh/pages/scanqr/scanqr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PelanggaranAddQrCode extends StatefulWidget {
  final String result;
  const PelanggaranAddQrCode({super.key, required this.result});

  @override
  State<PelanggaranAddQrCode> createState() => _PelanggaranAddQrCodeState();
}

class SiswaData {
  final String data1;
  final String data2;
  final String nomor_wali;

  SiswaData({
    required this.data1,
    required this.data2,
    required this.nomor_wali,
  });

  factory SiswaData.fromJson(Map<String, dynamic> json) {
    return SiswaData(
      data1: json['nama'],
      data2: json['kelas_nama'],
      nomor_wali: json['nomor_wali'] ?? '',
    );
  }
}

class _PelanggaranAddQrCodeState extends State<PelanggaranAddQrCode> {
  List<SiswaData> searchData = [];
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController jenisIdController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  bool isLoadingp = false;
  bool isPrefValueUsed = false;
  //Bluetooth
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevices;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  DateTime selectedDate = DateTime.now();
  String formattedDate =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  String nomor = "";
  bool isPrintSelected = false;
  bool isSaveSelected = false;
  List<Map<String, dynamic>> dropdownItems = [];
  Map<String, dynamic>? selectedDropdownitem;
  List<Map<String, dynamic>> dropdownItems2 = [];
  Map<String, dynamic>? selectedDropdownitem2;

  //FETCH DATA SISWA
  Future<List<SiswaData>> fetchdatasiswa(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    try {
      final response = await http.get(
        Uri.parse(Constants.baseUrl + Constants.siswaapi + widget.result),
        headers: {
          'Cookie': token,
        },
      );
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData is List) {
          List<SiswaData> newDataList =
              decodeData.map((item) => SiswaData.fromJson(item)).toList();
          return newDataList;
        } else {
          throw Exception("Invalid Data Format");
        }
      } else {
        throw Exception("Error ${response.reasonPhrase}");
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle specific error condition
        throw Exception(
            "Error: {$e} Connection closed before full header was received");
      }
      rethrow;
    }
  }

  //FETCH JENIS PELANGGARAN
  Future<List<Map<String, dynamic>>> fetchjenis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse(Constants.baseUrl + Constants.jenispelanggaranapi),
      headers: {
        'Cookie': token,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> data =
          jsonResponse.cast<Map<String, dynamic>>();
      return data;
    } else {
      // Get.snackbar(
      //   'Gagal mengambil data ',
      //   "Error ${response.reasonPhrase}",
      //   colorText: Colors.white,
      //   backgroundColor: Colors.red,
      //   icon: const Icon(Icons.add_alert),
      // );
      throw Exception("Gagal mengambil data ");
    }
  }

//Add Siswa
  Future<void> siswaAdd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    final response = await http.post(
      Uri.parse(Constants.baseUrl + Constants.pelanggaranapiadd),
      body: {
        'nis': nisController.text,
        'nama': namaController.text,
        'kelas': kelasController.text,
        'tanggal': selectedDate.toString(),
        'jenis_id': selectedDropdownitem2?['id'].toString(),
        'detail': detailController.text == null ? "" : detailController.text,
      },
      headers: {
        'Cookie': token,
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Sukses',
        "Data berhasil ditambahkan",
        colorText: Colors.white,
        backgroundColor: Colors.green[400],
        icon: const Icon(Icons.add_alert),
      );
      Get.to(() => const DashboardPages());
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal mengirim data',
        "Error ${response.reasonPhrase}",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_alert),
      );
    }
  }

  //SELECT DATE
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tanggalController.text = DateFormat('yyyy-MM-dd HH:mm').format(picked);
      });
    }
  }
// INIT STATE
@override
  void initState() {
    super.initState();

    // Fetch data siswa dan atur controller untuk nama dan kelas
    fetchdatasiswa("").then((data) {
      setState(() {
        searchData = data;
        namaController.text = searchData[0].data1;
        kelasController.text = searchData[0].data2;
        nomor = searchData[0].nomor_wali;
      });
    }).catchError((error) {
      print(error);
    });
Map<String, dynamic>? setInitialDropdownValue() {
    // Lakukan pengecekan apakah dropdownItems2 tidak kosong
    if (dropdownItems2.isNotEmpty) {
      // Misalnya, jika dropdownItems2 tidak kosong, atur nilai pertama sebagai nilai awal
      return dropdownItems2.lastWhere((element) => true);
    }
    // Jika tidak ada nilai yang dapat ditetapkan, kembalikan null
    return null;
  }

Future<void> loadSavedDropdownValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedValue = prefs.getString('jenis');
    if (savedValue != null && savedValue.isNotEmpty) {
      setState(() {
        selectedDropdownitem2 = json.decode(savedValue);
      });
    }
  }
    // Fetch jenis dan atur dropdown items
    fetchjenis().then((data2) {
      if (mounted) {
        setState(() {
          dropdownItems2 = data2;
          // Panggil loadSavedDropdownValue() untuk mengatur nilai awal dropdown
          loadSavedDropdownValue().then((_) {
            // Atur nilai awal dropdown hanya setelah nilai dari SharedPreferences dimuat
            selectedDropdownitem2 ??= setInitialDropdownValue();
          });
        });
      }
    });

    // Atur nilai NIS
    nisController.text = widget.result;
  }
  //UI DISINI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(10.0),
            //     bottomRight: Radius.circular(10.0)),
            ),
        title: Text(
          "Input Pelanggaran Siswa",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(ScanQr());
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Color(0xffffffff),
              size: 24,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _printData();
                siswaAdd();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "NIS",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          TextField(
                            controller: nisController,
                            obscureText: false,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "Nama",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: namaController,
                                obscureText: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xfff2f2f3),
                                  isDense: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                              if (namaController.text.isEmpty)
                                Center(child: CircularProgressIndicator()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "Kelas",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: kelasController,
                                obscureText: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                decoration: InputDecoration(
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: Color(0xfff2f2f3),
                                  isDense: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                              if (kelasController.text.isEmpty)
                                Center(child: CircularProgressIndicator()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tanggal",
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: formattedDate,
                            enabled: false,
                            obscureText: false,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00000000), width: 1),
                              ),
                              // hintText: "Tanggal",
                              // hintStyle: const TextStyle(
                              //   fontWeight: FontWeight.w400,
                              //   fontStyle: FontStyle.normal,
                              //   fontSize: 14,
                              //   color: Col**
                              //   or(0xff000000),
                              // ),
                              filled: true,
                              fillColor: const Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              suffixIcon: const Icon(Icons.calendar_today,
                                  color: Color(0xff212435), size: 24),
                            ),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "Pelanggaran",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xfff2f2f3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Data tidak boleh kosong";
                                        }
                                        return null;
                                      },
                                      value: selectedDropdownitem2,
                                      items: dropdownItems2
                                          .map<
                                              DropdownMenuItem<
                                                  Map<String, dynamic>>>(
                                            (item) => DropdownMenuItem<
                                                Map<String, dynamic>>(
                                              value: item,
                                              child: Text(item['nama']),
                                            ),
                                          )
                                          .toList(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      onChanged:
                                          (Map<String, dynamic>? newValue) {
                                        setState(() {
                                          selectedDropdownitem2 = newValue;
                                          prefs.setString(
                                              'jenis', json.encode(newValue));
                                        });
                                      },
                                      elevation: 8,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  // if (selectedDropdownitem2 == null) Center(child: CircularProgressIndicator()),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "Catatan",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          TextField(
                            controller: detailController,
                            obscureText: false,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xfff2f2f3),
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Object pelanggaran = selectedDropdownitem2 != null &&
                                selectedDropdownitem2!['jenis'] != null
                            ? selectedDropdownitem2!['jenis'].toString()
                            : dropdownItems2.isNotEmpty
                                ? dropdownItems2[0]
                                : "Tidak ada pelanggaran dipilih";
                        _printData();
                        siswaAdd();
                        //  if (nomor != "") {
                        //               launch(
                        //                 "https://wa.me/+${nomor}?text=\tPelanggaran atas nama\nNIS: ${nisController.text}\nNama: ${namaController.text}\nKelas: ${kelasController.text}\nTgl: ${formattedDate.toString()}\nPelanggaran: ${pelanggaran}\nCatatan: ${detailController.text}",
                        //               );
                        //             }
                      }
                    },
                    color: Color(0xff3c59ee),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                    minWidth: 140,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _printData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? printNewLine = prefs.getInt('printNewLine') ?? 0;

    String dataToPrint =
        buildPrintData(); // Tidak perlu argumen 'index' di sini
    for (int i = 0; i < printNewLine; i++) {
      dataToPrint += '\n'; // Menambahkan baris kosong ke dataToPrint
    }

    try {
      BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
      bool? isConnected = await bluetoothPrinter.isConnected;
      if (!isConnected!) {
        List<BluetoothDevice> devices =
            await bluetoothPrinter.getBondedDevices();
        if (devices.isNotEmpty) {
          BluetoothDevice printer = devices.first;
          await bluetoothPrinter.connect(printer);
        } else {
          print("Tidak ditemukan perangkat Bluetooth terikat");
          return;
        }
      }

      await bluetoothPrinter.write(dataToPrint);
      _showSuccessDialog(); // Jangan memutuskan koneksi di sini
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  String buildPrintData() {
    Object pelanggaran =
        selectedDropdownitem2 != null && selectedDropdownitem2!['jenis'] != null
            ? selectedDropdownitem2!['jenis'].toString()
            : dropdownItems2.isNotEmpty
                ? dropdownItems2[0]
                : "Tidak ada pelanggaran dipilih";

    String printData = """

    SIPATUH - PELANGGARAN SISWA
NIS: ${nisController.text}
Nama: ${namaController.text}
Kelas: ${kelasController.text}
Tgl: ${formattedDate.toString()}
Pelanggaran: ${pelanggaran} 
Catatan: ${detailController.text}

""";

    print("Data yang akan dicetak: $printData");

    return printData;
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: 'Sukses',
      middleText: 'Data berhasil disimpan',
      backgroundColor: Color.fromARGB(255, 5, 134, 9),
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      barrierDismissible: false,
      radius: 15.0,
      contentPadding: const EdgeInsets.all(20.0),
    );
    Future.delayed(Duration(seconds: 1), () {
      Get.back();
    });
  }
}
