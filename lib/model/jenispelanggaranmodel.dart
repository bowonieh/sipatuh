class JenisPelanggaranData {

  final int id;
  final String nama;
  final int poin;
  final String sanksi;



  JenisPelanggaranData(
      {required this.id,
      required this.nama,
      required this.poin,
      required this.sanksi
      });

  factory JenisPelanggaranData.fromJson(Map<String, dynamic> json) {
    return JenisPelanggaranData(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'],
      poin: int.tryParse(json['poin'].toString()) ?? 0,
      sanksi: json['sanksi'],
    );
  }
}