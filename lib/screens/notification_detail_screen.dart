import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  // Bu değişkenler, önceki sayfadan buraya taşınan verileri tutacak
  final String title;
  final String date;
  final String description;

  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirim Detayı"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih Bilgisi (İkonlu)
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Başlık
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D47A1), // Koyu Mavi
              ),
            ),
            const SizedBox(height: 24),

            // Ayırıcı Çizgi
            const Divider(thickness: 1),
            const SizedBox(height: 24),

            // Açıklama Metni
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5, // Satırların birbirine yapışmaması için
              ),
            ),
          ],
        ),
      ),
    );
  }
}