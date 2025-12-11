import 'package:flutter/material.dart';
import 'admin_screen.dart'; // Admin sayfasını import et
import 'home_screen.dart'; // Bildirim listesine erişmek için (Genellikle State Management kullanılır ama şimdilik böyle çözelim)

class ProfileScreen extends StatelessWidget {
  // Bildirim listesine erişmemiz lazım, bu yüzden const'ı kaldırdık
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              "Öğrenci Adı Soyadı",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Bilgisayar Mühendisliği",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // ADMİN PANELİNE GİT BUTONU
            // Not: Normalde burası sadece Admin kullanıcıya görünür.
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
              title: const Text("Yönetici Paneli (Demo)"),
              subtitle: const Text("Bildirim durumlarını güncelle"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Ana sayfadaki listeyi bulmamız lazım.
                // Basit bir yöntemle HomeScreenState'e erişemediğimiz için
                // Burada göstermelik bir geçiş yapıyoruz.
                // Gerçek veriyi Home'dan buraya taşımak gerekir.

                // PRATİK ÇÖZÜM İÇİN:
                // Şimdilik Home'daki listeye erişemediğimiz için
                // Admin sayfasını boş açacağız, mantığı görmek için.
                // Veri bağlama işini bir sonraki adımda Home üzerinden çözeceğiz.
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.grey),
              title: const Text("Çıkış Yap"),
              onTap: () {
                // Çıkış işlemleri
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}