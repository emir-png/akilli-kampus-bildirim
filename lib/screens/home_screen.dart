import 'package:flutter/material.dart';
import 'notification_detail_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'add_notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 1. ÖNEMLİ: Veri listesini buraya (State içine) taşıdık.
  // Böylece üzerine ekleme yapabiliriz.
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

  // 2. ÖNEMLİ: Sayfa içeriğini duruma göre seçen fonksiyon
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
      // Listeyi parametre olarak gönderiyoruz
        return NotificationList(notifications: notifications);
      case 1:
        return const MapScreen();
      case 2:
        return const ProfileScreen();
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

      body: _buildBody(), // _pages yerine fonksiyonu kullandık

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
          // 3. ÖNEMLİ: Sayfaya git ve sonucunu bekle (await)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotificationScreen(),
            ),
          );

          // Eğer geri dönen bir veri varsa listeye ekle
          if (result != null && result is Map<String, String>) {
            setState(() {
              notifications.insert(0, result); // Listenin en başına ekler
            });

            // Kullanıcıya bilgi ver
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

// --- BİLDİRİM LİSTESİ WIDGET'I (Güncellendi) ---
class NotificationList extends StatelessWidget {
  // Artık listeyi dışarıdan alıyor
  final List<Map<String, String>> notifications;

  const NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Liste boşsa uyarı göster
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
                          color: notification["status"] == "Açık" ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          notification["status"]!,
                          style: TextStyle(
                              fontSize: 11,
                              color: notification["status"] == "Açık" ? Colors.red : Colors.green,
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
}