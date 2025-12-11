import 'package:flutter/material.dart';
import 'notification_detail_screen.dart'; // 1. ÖNEMLİ: Dosyayı içeri aktardık

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Örnek Veri Listesi
  final List<Map<String, String>> notifications = [
    {
      "title": "Diş Randevusu Hatırlatması",
      "date": "11 Aralık 2025",
      "description": "Sayın hastamız, yarın saat 14:00'te diş temizliği randevunuz bulunmaktadır. Lütfen randevu saatinden 15 dakika önce klinikte olunuz."
    },
    {
      "title": "Sistem Bakım Çalışması",
      "date": "10 Aralık 2025",
      "description": "Uygulamamızda yapılacak planlı bakım çalışması nedeniyle 12 Aralık gecesi 02:00 - 04:00 saatleri arasında kesintiler yaşanabilir. Anlayışınız için teşekkür ederiz."
    },
    {
      "title": "Röntgen Analizi Hazır",
      "date": "08 Aralık 2025",
      "description": "Yüklediğiniz diş röntgeninin yapay zeka analizi tamamlandı. Sonuçları görüntülemek için detaylara gidiniz."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          // 2. ÖNEMLİ: GestureDetector ile sarmaladık
          return GestureDetector(
            onTap: () {
              // Karta tıklanınca Detay Sayfasına git ve verileri taşı
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
              elevation: 4,
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
                        // Expanded: Başlık uzun olursa diğer metnin üzerine binmesin
                        Expanded(
                          child: Text(
                            notification["title"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        // Tarih sağ tarafta sabit kalsın
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
                    // Açıklama: Listede sadece 2 satır görünsün, devamı "..." olsun
                    Text(
                      notification["description"]!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}