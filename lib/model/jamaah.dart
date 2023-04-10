// ignore_for_file: file_name, unnecessory_this, prefer_collection_literals

class Jamaah {
  int? id;
  String? nama;
  String? alamat;
  String? kelamin;
  String? tglLahir;
  String? kontak;

  Jamaah(
      {this.id,
      this.nama,
      this.alamat,
      this.kelamin,
      this.tglLahir,
      this.kontak});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['nama'] = nama;
    map['alamat'] = alamat;
    map['kelamin'] = kelamin;
    map['tglLahir'] = tglLahir;
    map['kontak'] = kontak;

    return map;
  }

  Jamaah.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nama = map['nama'];
    this.alamat = map['alamat'];
    this.kelamin = map['kelamin'];
    this.tglLahir = map['tglLahir'];
    this.kontak = map['kontak'];
  }
}
