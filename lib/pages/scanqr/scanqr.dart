import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/pages/dashboard.dart';
import 'package:magangsipatuh/pages/scanqr/pelanggaran_inputqr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  Barcode? result;
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3b58ec),
        appBar: AppBar(
          backgroundColor: const Color(0xff3b58ec),
          title: const Text(
            'Scan Qr Code',
            style: TextStyle(
              fontFamily: 'poppins',
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 18,
              color: Color(0xffffffff),
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.to(() => const DashboardPages());
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xffffffff),
              size: 24,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ));
  }

  Widget _buildQrView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: FutureBuilder(
                future: _controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return Icon(
                    Icons.flash_on,
                    color: snapshot.data == true ? Colors.yellow : Colors.white,
                  );
                },
              ),
              onPressed: () async {
                await _controller?.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              icon: FutureBuilder(
                future: _controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  IconData iconData = Icons.flip_camera_ios;
                  if (snapshot.data?.name == 'back') {
                    iconData = Icons.flip_camera_android;
                  }
                  return Icon(
                    iconData,
                    color: Colors.white, // Menambahkan warna putih pada ikon
                  );
                },
              ),
              onPressed: () async {
                await _controller?.flipCamera();
                setState(() {});
              },
            ),
          ],
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              var scanArea = constraints.maxWidth * 0.8;
              if (constraints.maxWidth < constraints.maxHeight) {
                scanArea = constraints.maxHeight * 0.4;
              }
              // Decrease the scanArea to detect codes from a closer distance
              scanArea *= 0.8; // You can adjust this factor as needed
              return QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: scanArea,
                ),
                onPermissionSet: (ctrl, p) =>
                    _onPermissionSet(context, ctrl, p),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!_isScanned) {
        setState(() {
          _isScanned = true;
        });

        String scannedNIS = scanData.code.toString();

        try {
          // var scannedStudent = students.firstWhere(
          //   (student) => student.nis == scannedNIS,
          //   orElse: () => Student(
          //     name: 'Unknown',
          //     nis: 0,
          //     kelas: 'Unknown',
          //     notelp: 0,
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PelanggaranAddQrCode(result: scannedNIS,)//QRinput(result: scannedNIS),
            ),
          );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error retrieving student data: $error'),
            ),
          );
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
