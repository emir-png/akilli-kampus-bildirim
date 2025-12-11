import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek bildirim verileri (Daha sonra veritabanından gelecek)
    final List<Map<String, String>> notifications = [
      {
        "title": "Vize Tarihleri Açıklandı",
        "date": "10 Ara 2025",
        "description": "Bilgisayar Mühendisliği 4. sınıf bitirme projesi sunum tarihleri belli oldu."
      },
      {
        "title": "Yemekhane Menüsü",
        "date": "11 Ara 2025",
        "description": "Bugün öğle yemeğinde: Yayla Çorbası, Orman Kebabı, Pilav ve Ayran var."
      },
      {
        "title": "Kütüphane Duyurusu",
        "date": "09 Ara 2025",
        "description": "Kütüphane çalışma saatleri vize haftası nedeniyle 7/24 olarak güncellenmiştir."
      },
      {
        "title": "Konferans Daveti",
        "date": "08 Ara 2025",
        "description": "Yapay Zeka ve Gelecek konulu konferansımız Rektörlük binasında yapılacaktır."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Akıllı Kampüs"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Ayarlar veya Çıkış işlemi buraya gelecek
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            elevation: 4, // Kartın gölgesi
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification["title"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        notification["date"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification["description"]!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // İleride buraya BottomNavigationBar ekleyebiliriz
    );
  }
}