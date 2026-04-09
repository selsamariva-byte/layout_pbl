import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataProduksiPage(),
    );
  }
}

class DataProduksiPage extends StatefulWidget {
  @override
  _DataProduksiPageState createState() => _DataProduksiPageState();
}

class _DataProduksiPageState extends State<DataProduksiPage> {
  List<Map<String, String>> dataProduksi = [];

  // controller
  TextEditingController namaController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();

  String selectedSatuan = "pcs";
  DateTime? selectedDate;

  void tambahData() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Tambah Produksi"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nama Produk
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(labelText: "Nama Produk"),
                  ),

                  SizedBox(height: 10),

                  // Tanggal
                  TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setStateDialog(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? "Pilih Tanggal"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),

                  // Jumlah
                  TextField(
                    controller: jumlahController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Jumlah"),
                  ),

                  SizedBox(height: 10),

                  // Satuan
                  DropdownButton<String>(
                    value: selectedSatuan,
                    isExpanded: true,
                    items: ["pcs", "botol", "box", "kg"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedSatuan = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String tanggal = selectedDate == null
                        ? "-"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

                    setState(() {
                      dataProduksi.add({
                        "nama": namaController.text,
                        "detail":
                            "$tanggal • ${jumlahController.text} $selectedSatuan",
                      });
                    });

                    // reset input
                    namaController.clear();
                    jumlahController.clear();
                    selectedDate = null;
                    selectedSatuan = "pcs";

                    Navigator.pop(context);
                  },
                  child: Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void hapusData(int index) {
    setState(() {
      dataProduksi.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Produksi"),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          // 🔍 Search + Tambah
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari produk...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(onPressed: tambahData, child: Text("+ Tambah")),
              ],
            ),
          ),

          // 📦 List / Empty
          Expanded(
            child: dataProduksi.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data produksi",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: dataProduksi.length,
                    itemBuilder: (context, index) {
                      final item = dataProduksi[index];

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Icon(Icons.factory),
                          title: Text(item["nama"]!),
                          subtitle: Text(item["detail"]!),

                          // 🗑️ HAPUS
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              hapusData(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        onPressed: tambahData,
        child: Icon(Icons.add),
      ),
    );
  }
}
