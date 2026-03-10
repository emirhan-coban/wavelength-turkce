# 🧠 Zihindar — Türkçe Wavelength Parti Oyunu

> Wavelength masa oyunundan ilham alan, tamamen Türkçe offline parti oyunu.

![Platform](https://img.shields.io/badge/platform-Flutter%20%7C%20React-orange)
![Language](https://img.shields.io/badge/dil-Türkçe-red)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## 📸 Ekranlar

| Ana Ekran | Oyuncu Ayarları | Kategori Seç | Telefonu Ver |
|-----------|----------------|--------------|--------------|
| Kelime Avı hero kartı, istatistikler | ± düğmesi, isim & renk seçimi | 6 kategori grid | Nabız animasyonlu avatar |

| Gizli Hedef | İpucu Ver | Tahmin Ekranı | Sonuç | Oyun Bitti |
|-------------|-----------|---------------|-------|------------|
| Dokun-aç, spektrum | Yazı girişi, kurallar | Sürüklenebilir ibre | Animasyonlu puan | Şampiyon + liderboard |

---

## 🎮 Nasıl Oynanır?

1. **Psişik Seçilir** — Her turda bir oyuncu psişik olur. Telefon o oyuncuya verilir.
2. **Gizli Hedef** — Psişik, spektrum üzerindeki gizli hedef noktasını görür. Başka kimse göremez!
3. **İpucu Ver** — Psişik, kartın iki kutbu arasındaki spektrumda hedefin konumunu anlatan **tek bir kelime veya kısa cümle** söyler.
4. **Grup Tahmin Eder** — Gruptaki diğer oyuncular tartışarak ibrenin nereye yerleştirileceğine karar verir.
5. **Puan Hesaplanır** — İbre hedefe ne kadar yakınsa o kadar çok puan!

### 🏆 Puan Tablosu

| Sonuç | Puan |
|-------|------|
| Tam İsabet (≤%8 mesafe) | **+40** |
| Çok Yakın (≤%16) | **+30** |
| Yakın (≤%25) | **+20** |
| Fena Değil (≤%35) | **+10** |
| Kaçırdınız | **+0** |

> Psişik tam isabette ayrıca **+20 bonus** puan alır!

---

## 📁 Proje Yapısı

```
wavelength/
├── wavelength_app/          # Flutter mobil uygulaması
│   └── lib/
│       ├── main.dart        # Uygulama giriş noktası + router
│       ├── models/
│       │   └── models.dart  # Veri modelleri & AppColors
│       ├── data/
│       │   └── game_cards.dart  # 108 oyun kartı (6 kategori)
│       ├── providers/
│       │   └── game_provider.dart  # Oyun mantığı (ChangeNotifier)
│       ├── screens/
│       │   ├── home_screen.dart
│       │   ├── player_setup_screen.dart
│       │   ├── category_select_screen.dart
│       │   ├── gameplay_screens.dart   # PhonePass, SecretTarget, Clue, Guess
│       │   └── result_screens.dart     # RoundResult, GameOver
│       └── widgets/
│           └── app_widgets.dart        # Paylaşılan UI bileşenleri
│
└── react_web/               # React web uygulaması (zihindar.web.app)
    └── src/
        ├── types/index.ts   # TypeScript tipleri & yardımcılar
        ├── data/
        │   └── gameCards.ts # 108 oyun kartı
        ├── store/
        │   └── gameStore.ts # Zustand state yönetimi
        ├── components/
        │   └── ui.tsx       # Paylaşılan React bileşenleri
        ├── screens/
        │   └── screens.tsx  # Tüm ekranlar
        ├── App.tsx          # Ana router
        └── main.tsx         # Giriş noktası
```

---

## 🃏 Kategoriler

| Kategori | Emoji | Kart Sayısı |
|----------|-------|-------------|
| Eğlence | 🎉 | 18 |
| Maceracı | ⚔️ | 18 |
| Zihin Oyunları | 🧠 | 18 |
| Klasik | 📚 | 20 |
| Rekabetçi | 🏆 | 18 |
| Sosyal | 👥 | 18 |
| **Toplam** | | **110** |

---

## 🚀 Kurulum & Çalıştırma

### Flutter (Mobil)

```bash
cd wavelength_app

# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır (bağlı cihaz veya emülatör)
flutter run

# Android APK derle
flutter build apk --release

# iOS IPA derle (macOS gerekli)
flutter build ios --release
```

**Gereksinimler:**
- Flutter SDK ≥ 3.10.4
- Dart SDK ≥ 3.0.0

### React Web

```bash
cd react_web

# Bağımlılıkları yükle
npm install

# Geliştirme sunucusunu başlat
npm run dev

# Production build
npm run build

# Preview
npm run preview
```

**Gereksinimler:**
- Node.js ≥ 18
- npm ≥ 9

---

## 🏗️ Teknoloji Yığını

### Flutter
| Paket | Versiyon | Kullanım |
|-------|----------|---------|
| `provider` | ^6.1.2 | State yönetimi |
| `google_fonts` | ^6.2.1 | Poppins font |
| `flutter_animate` | ^4.5.0 | Animasyonlar |
| `shared_preferences` | ^2.3.2 | Yerel depolama |
| `confetti` | ^0.7.0 | Konfeti efekti |
| `audioplayers` | ^6.1.0 | Ses efektleri |

### React
| Paket | Versiyon | Kullanım |
|-------|----------|---------|
| `react` | ^19 | UI framework |
| `zustand` | ^5 | State yönetimi |
| `framer-motion` | ^12 | Animasyonlar |
| `tailwindcss` | ^3 | Stil |
| `vite` | ^7 | Build tool |
| `typescript` | ^5 | Tip güvenliği |

---

## 🎨 Tasarım Sistemi

Uygulama koyu tema üzerine inşa edilmiş tutarlı bir renk paleti kullanır:

| Token | Renk | Hex |
|-------|------|-----|
| `orange` | Ana vurgu | `#FF6B00` |
| `background` | Arka plan | `#1A1A1A` |
| `surface` | Yüzey | `#242424` |
| `surfaceLight` | Açık yüzey | `#2E2E2E` |
| `success` | Başarı | `#4CAF50` |
| `error` | Hata | `#E53935` |

---

## 📱 Özellikler

- ✅ **Tamamen Türkçe** — Arayüz ve kartlar
- ✅ **Offline** — İnternet bağlantısı gerekmez
- ✅ **2-8 Oyuncu** desteği
- ✅ **6 Kategori**, 110+ kart
- ✅ **Gizli hedef** mekanizması (psişik ekranı korumalı)
- ✅ **Animasyonlu** puan gösterimi
- ✅ **Liderboard** takibi
- ✅ **Oyun istatistikleri** (tam isabet, ortalama puan)
- ✅ **Kategori filtreleme** — Seçili kategorilerden kart çekme
- ✅ **Renk/avatar** seçimi
- ✅ **Web versiyonu** (zihindar.web.app)

---

## 🌐 Web Versiyonu

Web versiyonu [zihindar.web.app](https://zihindar.web.app) adresinde yayında.

Firebase Hosting'e deploy etmek için:

```bash
cd react_web
npm run build

# Firebase CLI ile deploy
firebase deploy --only hosting
```

---

## 🤝 Katkıda Bulunma

1. Fork'layın
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: yeni özellik eklendi'`)
4. Branch'e push edin (`git push origin feature/yeni-ozellik`)
5. Pull Request açın

---

## 📄 Lisans

MIT © [emirhan-coban](https://github.com/emirhan-coban)

---

<div align="center">
  <strong>Zihindar</strong> ile arkadaşlarınla eğlenceye hazır mısın? 🧠⚡
</div>