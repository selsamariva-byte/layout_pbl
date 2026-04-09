import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProduksiPage extends StatefulWidget {
  @override
  _ProduksiPageState createState() => _ProduksiPageState();
}

class _ProduksiPageState extends State<ProduksiPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;
  String _status = 'Proses';

  // List produksi
  List<Map<String, String>> produksiList = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halaman Produksi",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // FORM INPUT PRODUKSI
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Nama Produk", _namaController),
                buildTextField("Kategori", _kategoriController),
                buildTextField("Jumlah", _jumlahController, isNumber: true),
                SizedBox(height: 10),

                // Tanggal Mulai & Selesai
                Row(
                  children: [
                    Expanded(
                      child: buildDatePicker("Tanggal Mulai", _tanggalMulai, (
                        date,
                      ) {
                        setState(() {
                          _tanggalMulai = date;
                        });
                      }),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildDatePicker(
                        "Tanggal Selesai",
                        _tanggalSelesai,
                        (date) {
                          setState(() {
                            _tanggalSelesai = date;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Status
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: ['Proses', 'Selesai', 'Tertunda']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _status = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 10),

                // Catatan
                buildTextField("Catatan", _catatanController),

                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _simpanProduksi,
                  child: Text("Simpan Produksi"),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // LIST PRODUKSI
          Text(
            "Daftar Produksi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: produksiList.length,
            itemBuilder: (context, index) {
              final item = produksiList[index];
              return Card(
                child: ListTile(
                  title: Text(item['nama']!),
                  subtitle: Text(
                    "Kategori: ${item['kategori']}, Jumlah: ${item['jumlah']}\n"
                    "Tanggal: ${item['mulai']} - ${item['selesai']}\n"
                    "Status: ${item['status']}\nCatatan: ${item['catatan']}",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        produksiList.removeAt(index); // hapus item di list
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==================== WIDGET BANTUAN ====================
  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Harap isi $label";
          }
          return null;
        },
      ),
    );
  }

  Widget buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onSelected(picked);
        }
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          date != null ? DateFormat('dd-MM-yyyy').format(date) : label,
        ),
      ),
    );
  }

  void _simpanProduksi() {
    if (_formKey.currentState!.validate() &&
        _tanggalMulai != null &&
        _tanggalSelesai != null) {
      setState(() {
        produksiList.add({
          'nama': _namaController.text,
          'kategori': _kategoriController.text,
          'jumlah': _jumlahController.text,
          'mulai': DateFormat('dd-MM-yyyy').format(_tanggalMulai!),
          'selesai': DateFormat('dd-MM-yyyy').format(_tanggalSelesai!),
          'status': _status,
          'catatan': _catatanController.text,
        });

        // reset form
        _namaController.clear();
        _kategoriController.clear();
        _jumlahController.clear();
        _catatanController.clear();
        _tanggalMulai = null;
        _tanggalSelesai = null;
        _status = 'Proses';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua field dengan benar")),
      );
    }
  }
}
