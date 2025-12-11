import 'package:flutter/material.dart';

class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({super.key});

  @override
  State<AddNotificationScreen> createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  // Form anahtarı (Validasyon için gerekli)
  final _formKey = GlobalKey<FormState>();

  // Değişkenler
  String? _selectedType;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Bildirim Türleri Listesi
  final List<String> _notificationTypes = [
    'Sağlık',
    'Güvenlik',
    'Teknik Arıza',
    'Kayıp Eşya',
    'Çevre Temizliği'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Bildirim Oluştur"),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TÜR SEÇİMİ (Dropdown)
              const Text("Bildirim Türü", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                hint: const Text("Türü Seçiniz"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: _notificationTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      children: [
                        // Türe göre ikon gösterimi (Opsiyonel ama şık durur)
                        Icon(_getIconForType(type), size: 20, color: Colors.grey[700]),
                        const SizedBox(width: 10),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                validator: (value) => value == null ? "Lütfen bir tür seçin" : null,
              ),
              const SizedBox(height: 20),

              // 2. BAŞLIK
              const Text("Başlık", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Örn: Kütüphane Girişi Su Sızıntısı",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Başlık boş bırakılamaz";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 3. AÇIKLAMA
              const Text("Açıklama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4, // Daha geniş bir alan
                decoration: InputDecoration(
                  hintText: "Detayları buraya yazınız...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Açıklama boş bırakılamaz";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 4. KONUM VE FOTOĞRAF (Butonlar)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // İleride buraya harita/konum kodu gelecek
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Konum başarıyla alındı (Simülasyon)")),
                        );
                      },
                      icon: const Icon(Icons.location_on, color: Colors.red),
                      label: const Text("Konum Ekle"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // İleride buraya kamera/galeri kodu gelecek
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fotoğraf seçildi (Simülasyon)")),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      label: const Text("Fotoğraf Ekle"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // GÖNDER BUTONU
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // YENİ KOD: Verileri bir harita (Map) olarak paketle
                    final newNotification = {
                      "title": _titleController.text,
                      "description": _descriptionController.text,
                      "date": "Şimdi", // Şimdilik statik, tarih kütüphanesiyle güncellenebilir
                      "status": "Açık",
                      "type": _selectedType ?? "Genel",
                    };

                    // Ana sayfaya bu veriyi göndererek dön
                    Navigator.pop(context, newNotification);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "BİLDİRİMİ GÖNDER",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Yardımcı Fonksiyon: Türlere göre ikon seçimi
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Sağlık': return Icons.local_hospital;
      case 'Güvenlik': return Icons.security;
      case 'Teknik Arıza': return Icons.build;
      case 'Kayıp Eşya': return Icons.search;
      case 'Çevre Temizliği': return Icons.cleaning_services;
      default: return Icons.warning;
    }
  }
}