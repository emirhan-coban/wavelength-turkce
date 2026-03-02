class SpectrumPair {
  final String leftConcept;
  final String rightConcept;
  final String categoryId;

  const SpectrumPair({
    required this.leftConcept,
    required this.rightConcept,
    required this.categoryId,
  });
}

class SpectrumData {
  static const List<SpectrumPair> allPairs = [
    // ─── Eğlence (Fun) ───
    SpectrumPair(
      leftConcept: 'Sıkıcı',
      rightConcept: 'Eğlenceli',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Sessiz',
      rightConcept: 'Gürültülü',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Kapalı Alan',
      rightConcept: 'Açık Hava',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Tek Başına',
      rightConcept: 'Kalabalık',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Planlı Eğlence',
      rightConcept: 'Spontane Eğlence',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Film İzlemek',
      rightConcept: 'Dışarı Çıkmak',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Kitap Okumak',
      rightConcept: 'Parti Yapmak',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Sakin Akşam',
      rightConcept: 'Çılgın Gece',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Basit Oyun',
      rightConcept: 'Karmaşık Oyun',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Geleneksel',
      rightConcept: 'Modern',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Ücretsiz',
      rightConcept: 'Lüks',
      categoryId: 'eglence',
    ),
    SpectrumPair(
      leftConcept: 'Kısa Süren',
      rightConcept: 'Uzun Süren',
      categoryId: 'eglence',
    ),

    // ─── Maceracı (Adventurous) ───
    SpectrumPair(
      leftConcept: 'Güvenli',
      rightConcept: 'Tehlikeli',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Planlı',
      rightConcept: 'Spontane',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Şehir',
      rightConcept: 'Doğa',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Kısa Yolculuk',
      rightConcept: 'Uzun Yolculuk',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Konforlu',
      rightConcept: 'Zorlu',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Tanıdık Yer',
      rightConcept: 'Bilinmeyen Yer',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Deniz',
      rightConcept: 'Dağ',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Yürüyüş',
      rightConcept: 'Koşu',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Gündüz',
      rightConcept: 'Gece',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Yerli',
      rightConcept: 'Yurt Dışı',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Kamp',
      rightConcept: 'Otel',
      categoryId: 'maceraci',
    ),
    SpectrumPair(
      leftConcept: 'Tek Başına',
      rightConcept: 'Grupla',
      categoryId: 'maceraci',
    ),

    // ─── Zihin Oyunları (Mind Games) ───
    SpectrumPair(
      leftConcept: 'Mantık',
      rightConcept: 'Hayal Gücü',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Kolay',
      rightConcept: 'Zor',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Somut',
      rightConcept: 'Soyut',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Bilgi',
      rightConcept: 'Sezgi',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Analiz',
      rightConcept: 'Yaratıcılık',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Gerçek',
      rightConcept: 'Kurgu',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Matematik',
      rightConcept: 'Sanat',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Hafıza',
      rightConcept: 'Dikkat',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Hız',
      rightConcept: 'Doğruluk',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Basit',
      rightConcept: 'Karmaşık',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Sabır',
      rightConcept: 'Refleks',
      categoryId: 'zihin',
    ),
    SpectrumPair(
      leftConcept: 'Strateji',
      rightConcept: 'Şans',
      categoryId: 'zihin',
    ),

    // ─── Klasik (Classic) ───
    SpectrumPair(
      leftConcept: 'Sıcak',
      rightConcept: 'Soğuk',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Eski',
      rightConcept: 'Yeni',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Büyük',
      rightConcept: 'Küçük',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Hızlı',
      rightConcept: 'Yavaş',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Gündüz',
      rightConcept: 'Gece',
      categoryId: 'klasik',
    ),
    SpectrumPair(leftConcept: 'Yaz', rightConcept: 'Kış', categoryId: 'klasik'),
    SpectrumPair(
      leftConcept: 'Tatlı',
      rightConcept: 'Tuzlu',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Yumuşak',
      rightConcept: 'Sert',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Ağır',
      rightConcept: 'Hafif',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Uzun',
      rightConcept: 'Kısa',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Açık',
      rightConcept: 'Koyu',
      categoryId: 'klasik',
    ),
    SpectrumPair(
      leftConcept: 'Geniş',
      rightConcept: 'Dar',
      categoryId: 'klasik',
    ),

    // ─── Rekabetçi (Competitive) ───
    SpectrumPair(
      leftConcept: 'Bireysel',
      rightConcept: 'Takım',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Güç',
      rightConcept: 'Strateji',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Saldırı',
      rightConcept: 'Savunma',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Amatör',
      rightConcept: 'Profesyonel',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Eğlence İçin',
      rightConcept: 'Kazanmak İçin',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Fiziksel',
      rightConcept: 'Zihinsel',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Sabırlı',
      rightConcept: 'Agresif',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Risk Almak',
      rightConcept: 'Güvenli Oynamak',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Deneyim',
      rightConcept: 'Yetenek',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Lider',
      rightConcept: 'Takipçi',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Hücum',
      rightConcept: 'Taktik',
      categoryId: 'rekabetci',
    ),
    SpectrumPair(
      leftConcept: 'Antrenman',
      rightConcept: 'Maç',
      categoryId: 'rekabetci',
    ),

    // ─── Sosyal (Social) ───
    SpectrumPair(
      leftConcept: 'İçe Dönük',
      rightConcept: 'Dışa Dönük',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Sakin',
      rightConcept: 'Enerjik',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Ciddi',
      rightConcept: 'Komik',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Dinleyici',
      rightConcept: 'Konuşkan',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Duygusal',
      rightConcept: 'Mantıklı',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Utangaç',
      rightConcept: 'Cesur',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Bağımsız',
      rightConcept: 'Bağımlı',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Gelenekçi',
      rightConcept: 'Yenilikçi',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Sabırlı',
      rightConcept: 'Sabırsız',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'İyimser',
      rightConcept: 'Kötümser',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Romantik',
      rightConcept: 'Pragmatik',
      categoryId: 'sosyal',
    ),
    SpectrumPair(
      leftConcept: 'Alçakgönüllü',
      rightConcept: 'Gösterişçi',
      categoryId: 'sosyal',
    ),
  ];

  static List<SpectrumPair> getPairsForCategory(String categoryId) {
    return allPairs.where((pair) => pair.categoryId == categoryId).toList();
  }
}
