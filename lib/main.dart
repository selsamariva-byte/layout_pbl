import 'package:flutter/material.dart';
import 'pages/produksi_page.dart'; // import halaman Produksi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 230,
            color: Color(0xFF2C3E50),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  "Sistem Informasi Pabrik Air",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 20),

                menuItem("Dashboard", Icons.home),
                menuItem("Karyawan", Icons.people),
                menuItem("Produksi", Icons.factory),
                menuItem("Gudang", Icons.warehouse),
                menuItem("Penjualan (POS)", Icons.point_of_sale),
                menuItem("Laporan", Icons.bar_chart),
                menuItem("Pengaturan", Icons.settings),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: Column(
              children: [
                // HEADER
                Container(
                  height: 70,
                  color: Color(0xFF34495E),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedMenu,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Row(
                        children: [
                          CircleAvatar(child: Icon(Icons.person)),
                          SizedBox(width: 10),
                          Text("Admin", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),

                // BODY
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: getContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MENU ITEM
  Widget menuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
      },
    );
  }

  // menampilkan konten sesuai menu
  Widget getContent() {
    switch (selectedMenu) {
      case "Karyawan":
        return centerText("Halaman Data Karyawan");
      case "Produksi":
        return ProduksiPage();
      case "Gudang":
        return centerText("Halaman Gudang");
      case "Penjualan (POS)":
        return centerText("Halaman POS / Kasir");
      default:
        return dashboard();
    }
  }

  // DASHBOARD
  Widget dashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),

        Row(
          children: [
            card("Karyawan", "50", Colors.blue),
            card("Produksi", "20", Colors.orange),
            card("Gudang", "150", Colors.green),
            card("Penjualan", "Rp 10jt", Colors.red),
          ],
        ),
      ],
    );
  }

  // CARD
  Widget card(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget centerText(String text) {
    return Center(child: Text(text, style: TextStyle(fontSize: 18)));
  }
}
