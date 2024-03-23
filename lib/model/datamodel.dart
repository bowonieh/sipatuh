import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magangsipatuh/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PelanggaranKategoriData {
  final int total;
  final String kategori;

  PelanggaranKategoriData({required this.total, required this.kategori});
  factory PelanggaranKategoriData.fromJson(Map<String, dynamic> json) {
    return PelanggaranKategoriData(
      total: json['total_siswa'],
      kategori: json['nama'],
    );
  }
}

class PelanggaranHariIniData {
  final int total;
  final String jenis;
  PelanggaranHariIniData({required this.total, required this.jenis});
  factory PelanggaranHariIniData.fromJson(Map<String, dynamic> json) {
    return PelanggaranHariIniData(
        total: json['total_siswa'], jenis: json['nama']);
  }
}

class PelanggaranPerKelasData {
  final int total;
  final String kelas;
  PelanggaranPerKelasData({required this.total, required this.kelas});
  factory PelanggaranPerKelasData.fromJson(Map<String, dynamic> json) {
    return PelanggaranPerKelasData(
        total: json['total_siswa'], kelas: json['nama']);
  }
}

Future<int> countSiswa() async {
  final dynamic apiUrl = Uri.parse(Constants.baseUrl + Constants.countSiswa);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalSiswa = int.parse(response.body);
      return totalSiswa;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total siswa');
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

//Count pelanggaran
Future<int> countPelanggaran() async {
  final dynamic apiUrl =
      Uri.parse(Constants.baseUrl + Constants.countPelanggaran);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalPelanggaran = int.parse(response.body);
      return totalPelanggaran;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total Pelanggaran');
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

Future<int> countPelanggaranToday() async {
  final dynamic apiUrl =
      Uri.parse(Constants.baseUrl + Constants.countPelanggaranToday);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      // API mengembalikan respons dengan kode status 200 (OK).
      // Ubah respons JSON ke integer (total siswa).
      int totalSiswa = int.parse(response.body);
      return totalSiswa;
    } else {
      // Tangani kesalahan jika respons tidak berhasil.
      throw Exception('Gagal mengambil data total siswa');
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

Future<List<PelanggaranHariIniData>> fetchPelanggaranHariIniData() async {
  final dynamic apiUrl = Uri.parse(Constants.baseUrl + Constants.pelanggaranPerHari);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<PelanggaranHariIniData> pelanggaranTodayData = jsonData
          .map((jsonItem) => PelanggaranHariIniData.fromJson(jsonItem))
          .toList();
      return pelanggaranTodayData;
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
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
    throw e;
  }
}

Future<List<PelanggaranKategoriData>> fetchPelanggaranKategoriData() async {
  final dynamic apiUrl =
      Uri.parse(Constants.baseUrl + Constants.kategoriPelanggaran);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<PelanggaranKategoriData> kategoriData = jsonData
          .map((jsonItem) => PelanggaranKategoriData.fromJson(jsonItem))
          .toList();
      return kategoriData;
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
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
    throw e;
  }
}

Future<List<PelanggaranPerKelasData>> fetchPelanggaranPerKelasData() async {
  final dynamic apiUrl =
      Uri.parse(Constants.baseUrl + Constants.pelanggaranPerKelas);
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('tokenJwt') ?? '';
  try {
    final response = await http.get(apiUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': token,
    });
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<PelanggaranPerKelasData> pelanggaranPerKelasData = jsonData
          .map((jsonItem) => PelanggaranPerKelasData.fromJson(jsonItem))
          .toList();
      return pelanggaranPerKelasData;
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
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
    throw e;
  }
}
