import '../models/models.dart';

// ─── Tüm Oyun Kartları ────────────────────────────────────────────────────────
class GameCards {
  static const List<GameCard> all = [
    // ── EĞLENCEategorisi ─────────────────────────────────────────────────────
    GameCard(
      id: 'e01',
      leftLabel: 'Sıkıcı',
      rightLabel: 'Eğlenceli',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e02',
      leftLabel: 'Sessiz Parti',
      rightLabel: 'Gürültülü Parti',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e03',
      leftLabel: 'Berbat Şaka',
      rightLabel: 'Harika Şaka',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e04',
      leftLabel: 'Utanç Verici',
      rightLabel: 'Gurur Verici',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e05',
      leftLabel: 'Hafif',
      rightLabel: 'Abartılı',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e06',
      leftLabel: 'Yalnız',
      rightLabel: 'Kalabalık',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e07',
      leftLabel: 'Ciddi',
      rightLabel: 'Komik',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e08',
      leftLabel: 'Sıradan',
      rightLabel: 'Efsane',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e09',
      leftLabel: 'Kötü Dans',
      rightLabel: 'Muhteşem Dans',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e10',
      leftLabel: 'Hüzünlü Film',
      rightLabel: 'Komedi Film',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e11',
      leftLabel: 'Sönük',
      rightLabel: 'Parlak',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e12',
      leftLabel: 'Uslu',
      rightLabel: 'Çılgın',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e13',
      leftLabel: 'Sabah Kahvaltısı',
      rightLabel: 'Gece Partisi',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e14',
      leftLabel: 'Sıradan Gün',
      rightLabel: 'Unutulmaz Gün',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e15',
      leftLabel: 'Kötü Hediye',
      rightLabel: 'Mükemmel Hediye',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e16',
      leftLabel: 'Sahte Gülüş',
      rightLabel: 'Gerçek Kahkaha',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e17',
      leftLabel: 'Ev Partisi',
      rightLabel: 'Kulüp Gecesi',
      category: CategoryType.eglence,
    ),
    GameCard(
      id: 'e18',
      leftLabel: 'Düz',
      rightLabel: 'Rengarenk',
      category: CategoryType.eglence,
    ),

    // ── MACERACI Kategorisi ───────────────────────────────────────────────────
    GameCard(
      id: 'm01',
      leftLabel: 'Güvenli',
      rightLabel: 'Tehlikeli',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm02',
      leftLabel: 'Ev Oturmacısı',
      rightLabel: 'Gezgin Ruh',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm03',
      leftLabel: 'Korkaklık',
      rightLabel: 'Cesaret',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm04',
      leftLabel: 'Konfor Zonu',
      rightLabel: 'Sınır Dışı',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm05',
      leftLabel: 'Planlı',
      rightLabel: 'Spontane',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm06',
      leftLabel: 'Alçak Ova',
      rightLabel: 'Dağ Zirvesi',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm07',
      leftLabel: 'Yavaş',
      rightLabel: 'Hızlı',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm08',
      leftLabel: 'Harita Var',
      rightLabel: 'Kaybolmuş',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm09',
      leftLabel: 'Sakin Deniz',
      rightLabel: 'Fırtınalı Okyanus',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm10',
      leftLabel: 'Tur Rehberi',
      rightLabel: 'Solo Gezgin',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm11',
      leftLabel: 'Şehir Turu',
      rightLabel: 'Vahşi Doğa',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm12',
      leftLabel: 'Yürüyüş',
      rightLabel: 'Tırmanış',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm13',
      leftLabel: 'Tatil Köyü',
      rightLabel: 'Çadır Hayatı',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm14',
      leftLabel: 'Kontrolde',
      rightLabel: 'Kontrolden Çıkmış',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm15',
      leftLabel: 'Rutinler',
      rightLabel: 'Sürprizler',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm16',
      leftLabel: 'Tanıdık Yer',
      rightLabel: 'Hiç Gidilmemiş Yer',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm17',
      leftLabel: 'Düşük Risk',
      rightLabel: 'Yüksek Risk',
      category: CategoryType.maceraci,
    ),
    GameCard(
      id: 'm18',
      leftLabel: 'Kısa Yolculuk',
      rightLabel: 'Uzun Keşif',
      category: CategoryType.maceraci,
    ),

    // ── ZİHİN OYUNLARI Kategorisi ─────────────────────────────────────────────
    GameCard(
      id: 'z01',
      leftLabel: 'Basit',
      rightLabel: 'Karmaşık',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z02',
      leftLabel: 'Duygusal',
      rightLabel: 'Mantıksal',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z03',
      leftLabel: 'Körü Körüne',
      rightLabel: 'Sorgulayan',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z04',
      leftLabel: 'Yüzeysel',
      rightLabel: 'Derin',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z05',
      leftLabel: 'Anlık',
      rightLabel: 'Uzun Vadeli',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z06',
      leftLabel: 'Somut',
      rightLabel: 'Soyut',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z07',
      leftLabel: 'Öğrenilmiş',
      rightLabel: 'Doğuştan',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z08',
      leftLabel: 'Kaos',
      rightLabel: 'Düzen',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z09',
      leftLabel: 'Akıl',
      rightLabel: 'Sezgi',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z10',
      leftLabel: 'Kural Takipçisi',
      rightLabel: 'Yaratıcı',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z11',
      leftLabel: 'Kısa Bellek',
      rightLabel: 'Uzun Bellek',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z12',
      leftLabel: 'Tek Boyutlu',
      rightLabel: 'Çok Boyutlu',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z13',
      leftLabel: 'Pasif',
      rightLabel: 'Aktif Düşünen',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z14',
      leftLabel: 'Ezber',
      rightLabel: 'Anlama',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z15',
      leftLabel: 'Ayrıntısız',
      rightLabel: 'Detaycı',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z16',
      leftLabel: 'Önyargılı',
      rightLabel: 'Tarafsız',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z17',
      leftLabel: 'Hızlı Karar',
      rightLabel: 'Uzun Düşünce',
      category: CategoryType.zihinOyunlari,
    ),
    GameCard(
      id: 'z18',
      leftLabel: 'Bütünü Görmek',
      rightLabel: 'Parçaları Görmek',
      category: CategoryType.zihinOyunlari,
    ),

    // ── KLASİK Kategorisi ─────────────────────────────────────────────────────
    GameCard(
      id: 'k01',
      leftLabel: 'Soğuk',
      rightLabel: 'Sıcak',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k02',
      leftLabel: 'Eski',
      rightLabel: 'Yeni',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k03',
      leftLabel: 'Küçük',
      rightLabel: 'Büyük',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k04',
      leftLabel: 'Yumuşak',
      rightLabel: 'Sert',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k05',
      leftLabel: 'Karanlık',
      rightLabel: 'Aydınlık',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k06',
      leftLabel: 'Yavaş',
      rightLabel: 'Hızlı',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k07',
      leftLabel: 'Ucuz',
      rightLabel: 'Pahalı',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k08',
      leftLabel: 'Kötü',
      rightLabel: 'İyi',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k09',
      leftLabel: 'Ağır',
      rightLabel: 'Hafif',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k10',
      leftLabel: 'Çirkin',
      rightLabel: 'Güzel',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k11',
      leftLabel: 'Zayıf',
      rightLabel: 'Güçlü',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k12',
      leftLabel: 'Gerçek',
      rightLabel: 'Sahte',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k13',
      leftLabel: 'Doğal',
      rightLabel: 'Yapay',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k14',
      leftLabel: 'Özgür',
      rightLabel: 'Kısıtlı',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k15',
      leftLabel: 'Sıradan',
      rightLabel: 'Özel',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k16',
      leftLabel: 'Kuru',
      rightLabel: 'Islak',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k17',
      leftLabel: 'Gürültülü',
      rightLabel: 'Sessiz',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k18',
      leftLabel: 'Geçmiş',
      rightLabel: 'Gelecek',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k19',
      leftLabel: 'Sakin',
      rightLabel: 'Enerjik',
      category: CategoryType.klasik,
    ),
    GameCard(
      id: 'k20',
      leftLabel: 'Uzak',
      rightLabel: 'Yakın',
      category: CategoryType.klasik,
    ),

    // ── REKABETÇİ Kategorisi ──────────────────────────────────────────────────
    GameCard(
      id: 'r01',
      leftLabel: 'Kaybedenin Şampiyonu',
      rightLabel: 'Kazananın Efsanesi',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r02',
      leftLabel: 'Takım Oyuncusu',
      rightLabel: 'Yıldız Oyuncu',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r03',
      leftLabel: 'Adil Oyun',
      rightLabel: 'Kazanmak Her Şey',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r04',
      leftLabel: 'Amatör',
      rightLabel: 'Profesyonel',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r05',
      leftLabel: 'Şanslı Başlangıç',
      rightLabel: 'Çalışarak Gelinen Zirve',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r06',
      leftLabel: 'Sessiz Sedasız',
      rightLabel: 'Gösteriş Gösteriş',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r07',
      leftLabel: 'Küçük Turnuva',
      rightLabel: 'Dünya Şampiyonası',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r08',
      leftLabel: 'Savunmacı',
      rightLabel: 'Saldırgan',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r09',
      leftLabel: 'Pratik',
      rightLabel: 'Teorik',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r10',
      leftLabel: 'Sabırlı',
      rightLabel: 'Sabırsız',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r11',
      leftLabel: 'Kötü Kayıp',
      rightLabel: 'Onurlu Kayıp',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r12',
      leftLabel: 'Solo Güç',
      rightLabel: 'Takım Gücü',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r13',
      leftLabel: 'Hazırlıksız',
      rightLabel: 'Hazır',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r14',
      leftLabel: 'Düşük Beklenti',
      rightLabel: 'Yüksek Beklenti',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r15',
      leftLabel: 'Keyfi',
      rightLabel: 'Hırs',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r16',
      leftLabel: 'Zayıf Rakip',
      rightLabel: 'Güçlü Rakip',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r17',
      leftLabel: 'İlk Hamle',
      rightLabel: 'Son Hamle',
      category: CategoryType.rekabetci,
    ),
    GameCard(
      id: 'r18',
      leftLabel: 'Kural Kitabı',
      rightLabel: 'Sezgisel Oyun',
      category: CategoryType.rekabetci,
    ),

    // ── SOSYAL Kategorisi ─────────────────────────────────────────────────────
    GameCard(
      id: 's01',
      leftLabel: 'İçe Dönük',
      rightLabel: 'Dışa Dönük',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's02',
      leftLabel: 'Utangaç',
      rightLabel: 'Cesur',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's03',
      leftLabel: 'Az Arkadaş',
      rightLabel: 'Çok Arkadaş',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's04',
      leftLabel: 'Dinleyen',
      rightLabel: 'Konuşan',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's05',
      leftLabel: 'Online İlişki',
      rightLabel: 'Yüz Yüze İlişki',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's06',
      leftLabel: 'Yüzeysel Sohbet',
      rightLabel: 'Derin Sohbet',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's07',
      leftLabel: 'Yabancı',
      rightLabel: 'Eski Dost',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's08',
      leftLabel: 'Sosyal Medya',
      rightLabel: 'Gerçek Hayat',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's09',
      leftLabel: 'Güven Vermez',
      rightLabel: 'Güven Verir',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's10',
      leftLabel: 'Yalnız Kurt',
      rightLabel: 'Sürü Lideri',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's11',
      leftLabel: 'Kısa Tanışma',
      rightLabel: 'Uzun Arkadaşlık',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's12',
      leftLabel: 'Çatışmacı',
      rightLabel: 'Uzlaşmacı',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's13',
      leftLabel: 'Bencil',
      rightLabel: 'Fedakâr',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's14',
      leftLabel: 'Soğuk İlişki',
      rightLabel: 'Samimi İlişki',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's15',
      leftLabel: 'Eleştirici',
      rightLabel: 'Destekleyici',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's16',
      leftLabel: 'Mesafeli',
      rightLabel: 'Sıcakkanlı',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's17',
      leftLabel: 'Hızlı Tanıdık',
      rightLabel: 'Zor Isınan',
      category: CategoryType.sosyal,
    ),
    GameCard(
      id: 's18',
      leftLabel: 'Pasif',
      rightLabel: 'Aktif',
      category: CategoryType.sosyal,
    ),
  ];

  /// Belirli kategorilere ait kartları karıştırıp döndür
  static List<GameCard> getShuffled(List<CategoryType> categories) {
    final filtered = categories.isEmpty
        ? List<GameCard>.from(all)
        : all.where((c) => categories.contains(c.category)).toList();
    filtered.shuffle();
    return filtered;
  }

  /// Sadece belirli kategoriden kartlar
  static List<GameCard> byCategory(CategoryType type) {
    return all.where((c) => c.category == type).toList();
  }
}
