// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database/db_helper.dart';
import 'model/jamaah.dart';

class FormJamaah extends StatefulWidget {
  final Jamaah? jamaah;

  FormJamaah({this.jamaah});

  @override
  State<FormJamaah> createState() => _FormJamaahState();
}

class _FormJamaahState extends State<FormJamaah> {
  DbHelper db = DbHelper();
  TextEditingController? nama;
  TextEditingController? alamat;
  String? kelamin;
  TextEditingController? tglLahir;
  TextEditingController? kontak;

  @override
  void initState() {
    nama = TextEditingController(
        text: widget.jamaah == null ? '' : widget.jamaah!.nama);

    alamat = TextEditingController(
        text: widget.jamaah == null ? '' : widget.jamaah!.alamat);

    kelamin = widget.jamaah == null ? 'Laki-laki' : widget.jamaah!.kelamin;

    tglLahir = TextEditingController(
        text: widget.jamaah == null ? '' : widget.jamaah!.tglLahir);

    kontak = TextEditingController(
        text: widget.jamaah == null ? '' : widget.jamaah!.kontak);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Jamaah'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: nama,
              decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: alamat,
              decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: tglLahir,
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "Masukkan Tanggal Lahir"),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1945),
                    lastDate: DateTime.now());
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    tglLahir?.text = formattedDate;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: kontak,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Kontak',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              children: <Widget>[
                Text('Jenis Kelamin'),
                ListTile(
                  title: const Text('Laki-Laki'),
                  leading: Radio(
                    value: 'Laki-laki',
                    groupValue: kelamin,
                    onChanged: (String? value) {
                      setState(() {
                        kelamin = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Perempuan'),
                  leading: Radio(
                    value: 'Perempuan',
                    groupValue: kelamin,
                    onChanged: (String? value) {
                      setState(() {
                        kelamin = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              child: (widget.jamaah == null)
                  ? Text(
                      'Tambah',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () {
                upsertJamaah();
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> upsertJamaah() async {
    String key_return;
    if (widget.jamaah != null) {
//update
      await db.updateJamaah(Jamaah.fromMap({
        'id': widget.jamaah!.id,
        'nama': nama!.text,
        'alamat': alamat!.text,
        'kelamin': kelamin,
        'tglLahir': tglLahir!.text,
        'kontak': kontak!.text
      }));
      key_return = 'update';
    } else {
//insert
      await db.saveJamaah(Jamaah(
          nama: nama!.text,
          alamat: alamat!.text,
          kelamin: kelamin,
          tglLahir: tglLahir!.text,
          kontak: kontak!.text));
      key_return = 'save';
    }
    if (!mounted) return;
    Navigator.pop(context, key_return);
  }
}
