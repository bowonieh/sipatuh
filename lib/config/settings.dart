import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Printer Manager class to manage printer connection
class PrinterManager {
  static final PrinterManager _instance = PrinterManager._internal();

  factory PrinterManager() {
    return _instance;
  }

  PrinterManager._internal();

  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  bool isConnected = false;
  BluetoothDevice? selectedDevice;

  Future<void> connectToDevice(
      BluetoothDevice? device, StateSetter setState) async {
    if (device != null) {
      await printer.connect(device);
      saveConnectionStatus(true);
      isConnected = true;
      selectedDevice = device;
      setState(() {
        selectedDevice = device;
      });
    }
  }

  Future<void> disconnectFromDevice() async {
    if (!isConnected) return; // Skip disconnection if not connected
    await printer.disconnect();
    saveConnectionStatus(false);
    isConnected = false;
  }

  Future<void> saveConnectionStatus(bool isConnected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPrinterConnected', isConnected);
  }

  Future<bool> getConnectionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPrinterConnected') ?? false;
  }
}

class SettingA extends StatefulWidget {
  const SettingA({Key? key}) : super(key: key);

  @override
  State<SettingA> createState() => _SettingAState();
}

class _SettingAState extends State<SettingA> {
  int index = 0;

  int? printNewLine;
  bool _isDisposed = false;
  int selectedEmptyLines = 0;
  bool isConnected = false;
  BluetoothDevice? selectedDevices;

  PrinterManager _printerManager = PrinterManager();

  List<BluetoothDevice> devices = [];
  String? selectedStatus = 'Langsung Cetak';
  String? selectedBaris = '1 Baris';
  String? selectedKirimPelanggaran = 'Ya';

  @override
  void initState() {
    super.initState();
    // Periksa status koneksi saat masuk ke halaman
    _printerManager.getConnectionStatus().then((value) {
      setState(() {
        isConnected = value;
      });
    });
    _loadPrintNewLine();
    getDevices();
  }

  void _loadPrintNewLine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      printNewLine = prefs.getInt('printNewLine');
    });
  }

  void _savePrintNewLine(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('printNewLine', value);
  }

  @override
  void dispose() {
    // Check if widget is already disposed
    if (!_isDisposed) {
      // Disconnect from device when leaving the settings page
      _printerManager.disconnectFromDevice();
      // Simpan status koneksi saat meninggalkan halaman
      _printerManager.saveConnectionStatus(isConnected);
      _isDisposed = true; // Update the flag to indicate widget disposal
    }
    super.dispose();
  }

  void getDevices() async {
    devices = await _printerManager.printer.getBondedDevices();
    // If there's a connected device, set it as selectedDevices
    if (isConnected && _printerManager.selectedDevice != null) {
      setState(() {
        selectedDevices = _printerManager.selectedDevice;
      });
    }
    setState(() {}); // Notify the UI about the changes
  }

  void simpanData() {
    print('Cetak Struk Pelanggaran: $selectedStatus');
    print('Tambah Bris Kosong: $selectedBaris');
    print('Kirim Pelanggaran: $selectedKirimPelanggaran');

    if (printNewLine != null) {
      // Simpan nilai printNewLine saat tombol simpan ditekan
      _savePrintNewLine(printNewLine!);
      // Memuat kembali nilai printNewLine untuk memperbarui tampilan
      _loadPrintNewLine();
      // Tampilkan pesan sukses atau tindakan lain yang sesuai
      // Anda dapat menambahkan logika yang sesuai di sini
      print('Nilai telah disimpan: $printNewLine');
    } else {
      // Tampilkan pesan kesalahan atau lakukan tindakan yang sesuai jika diperlukan
      print('Nilai tidak valid');
    }

    Get.defaultDialog(
      title: 'Sukses',
      middleText: 'Pengaturan berhasil disimpan',
      backgroundColor: Color.fromARGB(255, 3, 171, 8),
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
      navigateToDashboard(); // Navigate to DashboardAdmin
    });
  }

  void navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardPages()),
    );
  }

  void _printData(int index) async {
    try {
      BlueThermalPrinter bluetoothPrinter = BlueThermalPrinter.instance;
      List<BluetoothDevice> devices = await bluetoothPrinter.getBondedDevices();

      if (devices.isNotEmpty) {
        BluetoothDevice printer = devices.first;

        bool? isConnected = await bluetoothPrinter.isConnected;

        if (!isConnected!) {
          await bluetoothPrinter.connect(printer);
        }

        String printData = buildPrintData(index);
        await bluetoothPrinter.write(printData);
        await bluetoothPrinter.disconnect();
      } else {
        print("Tidak ditemukan perangkat Bluetooth terikat");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
    }
  }

  String buildPrintData(int index) {
    String printData = """   


Print berhasil
""";

    print("Data yang akan dicetak: $printData");

    return printData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3a57e8),
        shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.only(
            //     bottomLeft: Radius.circular(10.0),
            //     bottomRight: Radius.circular(10.0)),
            ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
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
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Color(0xffffffff),
              size: 24,
            ),
            onPressed: simpanData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<BluetoothDevice>(
                          isExpanded: true,
                          value: selectedDevices,
                          hint: Text(
                            'Pilih Printer',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff6c757d),
                            ),
                          ),

                          // underline: SizedBox(),
                          onChanged: (device) {
                            setState(() {
                              selectedDevices = device;
                              _printerManager.connectToDevice(
                                  device!, setState);
                            });
                          },
                          items: devices
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e.name!,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                        ),
                        // const SizedBox(height: 10),
                        if (selectedDevices != null)
                          Text(
                            'Perangkat terhubung: ${selectedDevices!.name}',
                            style: TextStyle(
                              color: isConnected ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    getDevices();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3a57e8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Mengatur borderRadius menjadi BorderRadius.zero
                    ),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // const Text(
            //   "Cetak Struk Pelanggaran",
            //   textAlign: TextAlign.start,
            //   overflow: TextOverflow.clip,
            //   style: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     fontStyle: FontStyle.normal,
            //     fontSize: 14,
            //     color: Color(0xff000000),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            //   child: DropdownButtonFormField<String>(
            //     value: selectedStatus,
            //     onChanged: (newValue) {
            //       setState(() {
            //         selectedStatus = newValue;
            //       });
            //     },
            //     items: <String>[
            //       'Langsung Cetak',
            //       'Konfirmasi Cetak',
            //       'Tidak Cetak',
            //     ].map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(
            //           value,
            //           style: TextStyle(fontWeight: FontWeight.w400),
            //         ),
            //       );
            //     }).toList(),
            //     decoration: InputDecoration(
            //       disabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide:
            //             const BorderSide(color: Color(0x00750808), width: 1),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide:
            //             const BorderSide(color: Color(0x00750808), width: 1),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide:
            //             const BorderSide(color: Color(0x00750808), width: 1),
            //       ),
            //       filled: true,
            //       fillColor: const Color(0xfff2f2f3),
            //       isDense: false,
            //       contentPadding:
            //           const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //     ),
            //   ),
            // ),
            const Text(
              "Tambah Baris Kosong",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: DropdownButtonFormField<String>(
                value: printNewLine != null ? '$printNewLine Baris' : null,
                onChanged: (newValue) {
                  setState(() {
                    printNewLine = int.parse(newValue!.split(' ')[0]);
                  });
                  // Simpan nilai printNewLine saat berubah
                  _savePrintNewLine(printNewLine!);
                },
                items: <String>[
                  '1 Baris',
                  '2 Baris',
                  '3 Baris',
                  '4 Baris',
                  '5 Baris'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Pilih jumlah baris kosong',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400, // Atur bobot font
                    fontStyle: FontStyle.normal, // Atur gaya font
                    fontSize: 14, // Atur ukuran font
                    color: Color(0xff6c757d), // Atur warna font
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            MaterialButton(
              onPressed: () {
                _printData(index);
              },
              color: Colors.green,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.print,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Test Print", // Teks pada tombol
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              height: 40,
              minWidth: 140,
            ),
            SizedBox(height: 10),
            MaterialButton(
              onPressed: simpanData,
              color: const Color(0xff3a57e8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Simpan",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              height: 40,
              minWidth: 140,
            ),
          ],
        ),
      ),
    );
  }
}
