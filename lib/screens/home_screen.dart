import 'package:flutter/material.dart';
import 'notification_detail_screen.dart';
import 'map_screen.dart';

import 'add_notification_screen.dart';
import 'admin_screen.dart'; // 1. YENİ: Admin ekranını import ettik

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Veri listesi (Burada duruyor ki hem Ana Sayfa hem Admin erişsin)
  List<Map<String, String>> notifications = [
    {
      "title": "Kütüphane Kliması Arızalı",
      "date": "10 dk önce",
      "description": "Merkez kütüphane 3. kat çalışma salonundaki klima su damlatıyor.",
      "status": "Açık"
    },
    {
      "title": "Kayıp Kimlik Kartı",
      "date": "1 saat önce",
      "description": "Yemekhane civarında mavi bir cüzdan bulundu.",
      "status": "Çözüldü"
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Sayfa içeriğini seçen fonksiyon
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
      // AKIŞ EKRANI
        return NotificationList(notifications: notifications);
      case 1:
      // HARİTA EKRANI
        return const MapScreen();
      case 2:
      // PROFİL EKRANI (Admin Paneli Butonu İçin Buraya Yazdık)
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF0D47A1),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                  "Emir (Admin)",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
              const Text(
                  "Bilgisayar Mühendisliği",
                  style: TextStyle(fontSize: 16, color: Colors.grey)
              ),
              const SizedBox(height: 30),

              // 2. YENİ: YÖNETİCİ PANELİ BUTONU
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800], // Admin rengi
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  // Admin Paneline git ve listeyi gönder
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminScreen(notifications: notifications),
                    ),
                  ).then((_) {
                    // 3. YENİ: Admin panelinden dönünce sayfayı yenile
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                label: const Text("Yönetici Paneli", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),

              const SizedBox(height: 16),
              // Çıkış Butonu (Görsel)
              TextButton.icon(
                onPressed: () {
                  // Giriş ekranına döndürebilirsin
                },
                icon: const Icon(Icons.logout, color: Colors.grey),
                label: const Text("Çıkış Yap", style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        );
      default:
        return const NotificationList(notifications: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akıllı Kampüs"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),

      body: _buildBody(),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Akış'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Harita'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0D47A1),
        onTap: _onItemTapped,
      ),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotificationScreen(),
            ),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              notifications.insert(0, result);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Bildirim eklendi!"), backgroundColor: Colors.green),
            );
          }
        },
        backgroundColor: const Color(0xFF0D47A1),
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}

// --- BİLDİRİM LİSTESİ WIDGET'I ---
class NotificationList extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(child: Text("Henüz bildirim yok."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationDetailScreen(
                  title: notification["title"]!,
                  date: notification["date"]!,
                  description: notification["description"]!,
                ),
              ),
            );
          },
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification["title"]!,
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          // Duruma göre renk değişimi (Açık: Kırmızı, İnceleniyor: Turuncu, Çözüldü: Yeşil)
                          color: _getStatusColor(notification["status"]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          notification["status"]!,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification["description"]!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification["date"]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Renk yardımcı fonksiyonu
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Açık': return Colors.red;
      case 'İnceleniyor': return Colors.orange;
      case 'Çözüldü': return Colors.green;
      default: return Colors.grey;
    }
  }
}