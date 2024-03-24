class Constants {
  static const String baseUrl = 'http://203.175.11.144:8082/';
  static const String login = 'indexapi/login';
  static const String checklogin = 'indexapi/checkloginstate';
  static const String guruApi = 'guruapi/apilist?search=';
  static const String pelanggaranPerKelas = 'dashboardapi/pelanggaranperkelas';
  static const String pelanggaranPerHari = 'dashboardapi/pelanggaranbyday';
  static const String kategoriPelanggaran = 'dashboardapi/kategoripelanggaran';
  static const String countSiswa = 'dashboardapi/countsiswa';
  static const String countPelanggaran = 'dashboardapi/countpelanggaran';
  static const String countPelanggaranToday = 'dashboardapi/counthariini';
  static const String siswaapi = 'siswaapi/?search=';
  static const String kelasapi = 'kelasapi/?search=';


  /**
   * GET
@guru
- [domain]/guruapi/apilist (OKE)
- [domain]/guruapi/apilist?search=keyword (oke)
@index
- [domain]/indexapi/dashboard 
*countsiswa (dashboardapi/countsiswa) (OKE)
*countpelanggaran (dashboardapi/countpelanggaran) (OKE)
*counthariini (dashboardapi/counthariini) (OKE)
- [domain]/indexapi/kategoripelanggaran (dashboardapi/kategoripelanggaran) (OKE)
- [domain]/indexapi/pelanggaranbyday (dashboardapi/pelanggaranbyday) (OKE)
- [domain]/indexapi/pelanggaranperkelas (dashboardapi/pelanggaranperkelas) (OKE)

@jenis_pelanggaran
- [domain]/jenispelanggaranapi (OKE)
- [domain]/jenispelanggaranapi?search=keyword (OKE)

@jurusan
- [domain]/jurusanapi (OKE)
- [domain]/jurusanapi?search=keyword (OKE)
@kelas
- [domain]/kelasapi (OKE)
- [domain]/kelasapi?search=keyword (OKE)

@pelanggaran
- [domain]/pelanggaranapi (OKE)
- [domain]/pelanggaranapi?search=keyword (OKE)
- [domain]/sipatuh-2/pelanggaranapi/add (OKE)
* nis
* nama
* kelas
* tanggal
* jenis_id
* detail

@siswa
- [domain]/siswaapi (OKE)
- [domain]/siswaapi?search=keyword (OKE)
@wali_murid
- [domain]/walimuridapi (OKE)
- [domain]/walimuridapi?search=keyword (OKE)

POST
- [domain]/sipatuh-2/indexapi/login (OKE)
* username
* password



- [domain]/sipatuh-2/indexapi/logout (OKE)
   */
}