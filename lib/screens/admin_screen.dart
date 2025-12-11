import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  // Ana sayfadaki listeyi buraya referans olarak alıyoruz
  final List<Map<String, String>> notifications;

  const AdminScreen({super.key, required this.notifications});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Durum değiştirme fonksiyonu
  void _changeStatus(int index) {
    setState(() {
      String currentStatus = widget.notifications[index]['status']!;

      // Döngüsel durum değişimi: Açık -> İnceleniyor -> Çözüldü -> Açık
      if (currentStatus == "Açık") {
        widget.notifications[index]['status'] = "İnceleniyor";
      } else if (currentStatus == "İnceleniyor") {
        widget.notifications[index]['status'] = "Çözüldü";
      } else {
        widget.notifications[index]['status'] = "Açık";
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Durum güncellendi: ${widget.notifications[index]['status']}"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Paneli"),
        backgroundColor: Colors.red[800], // Admin olduğu belli olsun diye kırmızı
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.notifications.length,
        itemBuilder: (context, index) {
          final notification = widget.notifications[index];
          return Card(
            child: ListTile(
              leading: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.red[800]
              ),
              title: Text(notification['title']!),
              subtitle: Text("Durum: ${notification['status']}"),
              trailing: ElevatedButton(
                onPressed: () => _changeStatus(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(notification['status']!),
                ),
                child: const Text("Değiştir", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Açık': return Colors.red;
      case 'İnceleniyor': return Colors.orange;
      case 'Çözüldü': return Colors.green;
      default: return Colors.grey;
    }
  }
}