// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors,avoid_function_literals_in_foreach_calls, non_constant_identifier_names, unused_element,unused_local_variable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'form_jamaah.dart';

import 'database/db_helper.dart';
import 'model/jamaah.dart';

class ListJamaahPage extends StatefulWidget {
  const ListJamaahPage({Key? key}) : super(key: key);

  @override
  State<ListJamaahPage> createState() => _ListJamaahPageState();
}

class _ListJamaahPageState extends State<ListJamaahPage> {
  List<Jamaah> listJamaah = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
//menjalankan fungsi getallJamaah saat pertama kali dimuat
    _getAllJamaah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Jamaah App"),
        ),
      ),
      body: ListView.builder(
          itemCount: listJamaah.length,
          itemBuilder: (context, index) {
            Jamaah jamaah = listJamaah[index];
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  size: 50,
                  color: (jamaah.kelamin == 'Laki-laki')
                      ? Colors.blue
                      : Colors.pink,
                ),
                title: Text('${jamaah.nama}'),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Alamat: ${jamaah.alamat}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Kontak: ${jamaah.kontak}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Umur: ${calculateAge(jamaah.tglLahir)}"),
                    ),
                  ],
                ),
                trailing: FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
// button edit
                      IconButton(
                          onPressed: () {
                            _openFormEdit(jamaah);
                          },
                          icon: Icon(Icons.edit)),
// button hapus
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
//membuat dialog konfirmasi hapus
                          AlertDialog hapus = AlertDialog(
                            title: Text("Information"),
                            content: Container(
                              height: 100,
                              child: Column(
                                children: [
                                  Text(
                                      "Yakin ingin Menghapus Data ${jamaah.nama}")
                                ],
                              ),
                            ),

//terdapat 2 button.
//jika ya maka jalankan _deleteKontak() dan tutup dialog
//jika tidak maka tutup dialog
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _deleteJamaah(jamaah, index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ya")),
                              TextButton(
                                child: Text('Tidak'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                          showDialog(
                              context: context, builder: (context) => hapus);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
//membuat button mengapung di bagian bawah kanan layar
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

//mengambil semua data Jamaah
  Future<void> _getAllJamaah() async {
//list menampung data dari database
    var list = await db.getAllJamaah();

//ada perubahan state
    setState(() {
//hapus data pada listJamaah
      listJamaah.clear();

//lakukan perulangan pada variabel list
      list!.forEach((jamaah) {
//masukan data ke listJamaah
        listJamaah.add(Jamaah.fromMap(jamaah));
      });
    });
  }

//menghapus data Jamaah
  Future<void> _deleteJamaah(Jamaah jamaah, int position) async {
    await db.deleteJamaah(jamaah.id!);
    setState(() {
      listJamaah.removeAt(position);
    });
  }

// membuka halaman tambah Jamaah
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormJamaah()));
    if (result == 'save') {
      await _getAllJamaah();
    }
  }

//membuka halaman edit Jamaah
  Future<void> _openFormEdit(Jamaah jamaah) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => FormJamaah(jamaah: jamaah)));
    if (result == 'update') {
      await _getAllJamaah();
    }
  }
}

int calculateAge(String? birthDate) {
  DateTime birthDateString = DateFormat('yyyy-MM-dd').parse(birthDate!);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDateString.year;
  if (currentDate.month < birthDateString.month ||
      (currentDate.month == birthDateString.month &&
          currentDate.day < birthDateString.day)) {
    age--;
  }
  return age;
}
