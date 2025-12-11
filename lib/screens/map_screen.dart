import 'package:flutter/material.dart';
import 'notification_detail_screen.dart'; // Detay sayfasına gitmek için

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Harita üzerindeki örnek bildirimler (Konumları x ve y koordinatlarıyla simüle ediyoruz)
  final List<Map<String, dynamic>> mapNotifications = [
    {
      "id": 1,
      "title": "Kütüphane Kliması Arızalı",
      "type": "Teknik Arıza",
      "status": "Açık",
      "x": 150.0, // Haritadaki yatay konumu
      "y": 100.0, // Haritadaki dikey konumu
      "description": "3. kat çalışma salonu çok sıcak, klima çalışmıyor."
    },
    {
      "id": 2,
      "title": "Kayıp Cüzdan",
      "type": "Kayıp Eşya",
      "status": "Çözüldü",
      "x": 250.0,
      "y": 300.0,
      "description": "Mavi deri cüzdan yemekhane girişinde bulundu."
    },
    {
      "id": 3,
      "title": "Şüpheli Paket",
      "type": "Güvenlik",
      "status": "İnceleniyor",
      "x": 80.0,
      "y": 450.0,
      "description": "A Kapısı girişinde sahipsiz bir çanta var."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Doküman Madde 3: "Kullanıcı harita üzerinde yakınlaştırma/uzaklaştırma yapabilir."
      // InteractiveViewer bu işi otomatik yapar (Pinch to zoom)
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Stack(
          children: [
            // 1. KATMAN: HARİTA GÖRSELİ
            // Atatürk Üniversitesi Kampüs Haritası
            Container(
              height: 1000,
              width: 1000,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // İnternetten bulunan Atatürk Üniversitesi kampüs haritası
                  image: NetworkImage("https://www.atauni.edu.tr/wp-content/uploads/2020/10/kampus_haritasi.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. KATMAN: PİNLER (İğneler)
            // Listemizdeki her bildirim için haritaya bir ikon koyuyoruz
            ...mapNotifications.map((notification) {
              return Positioned(
                left: notification['x'],
                top: notification['y'],
                child: GestureDetector(
                  onTap: () {
                    _showPinInfoCard(context, notification);
                  },
                  child: Column(
                    children: [
                      // Zıplayan Pin Efekti (Animasyonlu gibi dursun)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                            ]
                        ),
                        child: Icon(
                          _getIconForType(notification['type']),
                          color: _getColorForStatus(notification['status']),
                          size: 30,
                        ),
                      ),
                      // Pin'in ucu
                      Icon(Icons.arrow_drop_down, size: 24, color: _getColorForStatus(notification['status'])),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),

      // Harita olduğunu belli eden bir buton (Opsiyonel süs)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Konuma git (Simülasyon)
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Konumunuz ortalanıyor...")));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    );
  }

  // Doküman Madde 3: "Pin Bilgi Kartı"
  // Pin tıklanınca alttan açılan pencere
  void _showPinInfoCard(BuildContext context, Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250, // Kart yüksekliği
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım: Başlık ve Kapatma Çizgisi
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(_getIconForType(notification['type']), color: _getColorForStatus(notification['status']), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Durum Etiketi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // DÜZELTİLEN KISIM BURASI: withOpacity yerine withValues kullanıldı
                        color: _getColorForStatus(notification['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(notification['status'], style: TextStyle(color: _getColorForStatus(notification['status']), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(notification['description'], style: TextStyle(color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),

              // Doküman Madde 3: "Kart üzerindeki Detayı Gör butonu"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Önce kartı kapat
                    // Sonra detay sayfasına git
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailScreen(
                          title: notification['title'],
                          date: "Harita Konumu",
                          description: notification['description'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Detayı Gör", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Yardımcılar
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Sağlık': return Icons.local_hospital;
      case 'Güvenlik': return Icons.security;
      case 'Teknik Arıza': return Icons.build;
      case 'Kayıp Eşya': return Icons.search;
      default: return Icons.location_on;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Açık': return Colors.red;
      case 'İnceleniyor': return Colors.orange;
      case 'Çözüldü': return Colors.green;
      default: return Colors.blue;
    }
  }
}