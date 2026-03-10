import type { GameCard, CategoryType } from "../types";

export const ALL_CARDS: GameCard[] = [
  // ── EĞLENCE ─────────────────────────────────────────────────────────────────
  {
    id: "e01",
    leftLabel: "Sıkıcı",
    rightLabel: "Eğlenceli",
    category: "eglence",
  },
  {
    id: "e02",
    leftLabel: "Sessiz Parti",
    rightLabel: "Gürültülü Parti",
    category: "eglence",
  },
  {
    id: "e03",
    leftLabel: "Berbat Şaka",
    rightLabel: "Harika Şaka",
    category: "eglence",
  },
  {
    id: "e04",
    leftLabel: "Utanç Verici",
    rightLabel: "Gurur Verici",
    category: "eglence",
  },
  {
    id: "e05",
    leftLabel: "Hafif",
    rightLabel: "Abartılı",
    category: "eglence",
  },
  {
    id: "e06",
    leftLabel: "Yalnız",
    rightLabel: "Kalabalık",
    category: "eglence",
  },
  { id: "e07", leftLabel: "Ciddi", rightLabel: "Komik", category: "eglence" },
  {
    id: "e08",
    leftLabel: "Sıradan",
    rightLabel: "Efsane",
    category: "eglence",
  },
  {
    id: "e09",
    leftLabel: "Kötü Dans",
    rightLabel: "Muhteşem Dans",
    category: "eglence",
  },
  {
    id: "e10",
    leftLabel: "Hüzünlü Film",
    rightLabel: "Komedi Film",
    category: "eglence",
  },
  { id: "e11", leftLabel: "Sönük", rightLabel: "Parlak", category: "eglence" },
  { id: "e12", leftLabel: "Uslu", rightLabel: "Çılgın", category: "eglence" },
  {
    id: "e13",
    leftLabel: "Sabah Kahvaltısı",
    rightLabel: "Gece Partisi",
    category: "eglence",
  },
  {
    id: "e14",
    leftLabel: "Sıradan Gün",
    rightLabel: "Unutulmaz Gün",
    category: "eglence",
  },
  {
    id: "e15",
    leftLabel: "Kötü Hediye",
    rightLabel: "Mükemmel Hediye",
    category: "eglence",
  },
  {
    id: "e16",
    leftLabel: "Sahte Gülüş",
    rightLabel: "Gerçek Kahkaha",
    category: "eglence",
  },
  {
    id: "e17",
    leftLabel: "Ev Partisi",
    rightLabel: "Kulüp Gecesi",
    category: "eglence",
  },
  { id: "e18", leftLabel: "Düz", rightLabel: "Rengarenk", category: "eglence" },

  // ── MACERACI ─────────────────────────────────────────────────────────────────
  {
    id: "m01",
    leftLabel: "Güvenli",
    rightLabel: "Tehlikeli",
    category: "maceraci",
  },
  {
    id: "m02",
    leftLabel: "Ev Oturmacısı",
    rightLabel: "Gezgin Ruh",
    category: "maceraci",
  },
  {
    id: "m03",
    leftLabel: "Korkaklık",
    rightLabel: "Cesaret",
    category: "maceraci",
  },
  {
    id: "m04",
    leftLabel: "Konfor Zonu",
    rightLabel: "Sınır Dışı",
    category: "maceraci",
  },
  {
    id: "m05",
    leftLabel: "Planlı",
    rightLabel: "Spontane",
    category: "maceraci",
  },
  {
    id: "m06",
    leftLabel: "Alçak Ova",
    rightLabel: "Dağ Zirvesi",
    category: "maceraci",
  },
  { id: "m07", leftLabel: "Yavaş", rightLabel: "Hızlı", category: "maceraci" },
  {
    id: "m08",
    leftLabel: "Harita Var",
    rightLabel: "Kaybolmuş",
    category: "maceraci",
  },
  {
    id: "m09",
    leftLabel: "Sakin Deniz",
    rightLabel: "Fırtınalı Okyanus",
    category: "maceraci",
  },
  {
    id: "m10",
    leftLabel: "Tur Rehberi",
    rightLabel: "Solo Gezgin",
    category: "maceraci",
  },
  {
    id: "m11",
    leftLabel: "Şehir Turu",
    rightLabel: "Vahşi Doğa",
    category: "maceraci",
  },
  {
    id: "m12",
    leftLabel: "Yürüyüş",
    rightLabel: "Tırmanış",
    category: "maceraci",
  },
  {
    id: "m13",
    leftLabel: "Tatil Köyü",
    rightLabel: "Çadır Hayatı",
    category: "maceraci",
  },
  {
    id: "m14",
    leftLabel: "Kontrolde",
    rightLabel: "Kontrolden Çıkmış",
    category: "maceraci",
  },
  {
    id: "m15",
    leftLabel: "Rutinler",
    rightLabel: "Sürprizler",
    category: "maceraci",
  },
  {
    id: "m16",
    leftLabel: "Tanıdık Yer",
    rightLabel: "Hiç Gidilmemiş Yer",
    category: "maceraci",
  },
  {
    id: "m17",
    leftLabel: "Düşük Risk",
    rightLabel: "Yüksek Risk",
    category: "maceraci",
  },
  {
    id: "m18",
    leftLabel: "Kısa Yolculuk",
    rightLabel: "Uzun Keşif",
    category: "maceraci",
  },

  // ── ZİHİN OYUNLARI ───────────────────────────────────────────────────────────
  {
    id: "z01",
    leftLabel: "Basit",
    rightLabel: "Karmaşık",
    category: "zihinOyunlari",
  },
  {
    id: "z02",
    leftLabel: "Duygusal",
    rightLabel: "Mantıksal",
    category: "zihinOyunlari",
  },
  {
    id: "z03",
    leftLabel: "Körü Körüne",
    rightLabel: "Sorgulayan",
    category: "zihinOyunlari",
  },
  {
    id: "z04",
    leftLabel: "Yüzeysel",
    rightLabel: "Derin",
    category: "zihinOyunlari",
  },
  {
    id: "z05",
    leftLabel: "Anlık",
    rightLabel: "Uzun Vadeli",
    category: "zihinOyunlari",
  },
  {
    id: "z06",
    leftLabel: "Somut",
    rightLabel: "Soyut",
    category: "zihinOyunlari",
  },
  {
    id: "z07",
    leftLabel: "Öğrenilmiş",
    rightLabel: "Doğuştan",
    category: "zihinOyunlari",
  },
  {
    id: "z08",
    leftLabel: "Kaos",
    rightLabel: "Düzen",
    category: "zihinOyunlari",
  },
  {
    id: "z09",
    leftLabel: "Akıl",
    rightLabel: "Sezgi",
    category: "zihinOyunlari",
  },
  {
    id: "z10",
    leftLabel: "Kural Takipçisi",
    rightLabel: "Yaratıcı",
    category: "zihinOyunlari",
  },
  {
    id: "z11",
    leftLabel: "Kısa Bellek",
    rightLabel: "Uzun Bellek",
    category: "zihinOyunlari",
  },
  {
    id: "z12",
    leftLabel: "Tek Boyutlu",
    rightLabel: "Çok Boyutlu",
    category: "zihinOyunlari",
  },
  {
    id: "z13",
    leftLabel: "Pasif",
    rightLabel: "Aktif Düşünen",
    category: "zihinOyunlari",
  },
  {
    id: "z14",
    leftLabel: "Ezber",
    rightLabel: "Anlama",
    category: "zihinOyunlari",
  },
  {
    id: "z15",
    leftLabel: "Ayrıntısız",
    rightLabel: "Detaycı",
    category: "zihinOyunlari",
  },
  {
    id: "z16",
    leftLabel: "Önyargılı",
    rightLabel: "Tarafsız",
    category: "zihinOyunlari",
  },
  {
    id: "z17",
    leftLabel: "Hızlı Karar",
    rightLabel: "Uzun Düşünce",
    category: "zihinOyunlari",
  },
  {
    id: "z18",
    leftLabel: "Bütünü Görmek",
    rightLabel: "Parçaları Görmek",
    category: "zihinOyunlari",
  },

  // ── KLASİK ───────────────────────────────────────────────────────────────────
  { id: "k01", leftLabel: "Soğuk", rightLabel: "Sıcak", category: "klasik" },
  { id: "k02", leftLabel: "Eski", rightLabel: "Yeni", category: "klasik" },
  { id: "k03", leftLabel: "Küçük", rightLabel: "Büyük", category: "klasik" },
  { id: "k04", leftLabel: "Yumuşak", rightLabel: "Sert", category: "klasik" },
  {
    id: "k05",
    leftLabel: "Karanlık",
    rightLabel: "Aydınlık",
    category: "klasik",
  },
  { id: "k06", leftLabel: "Yavaş", rightLabel: "Hızlı", category: "klasik" },
  { id: "k07", leftLabel: "Ucuz", rightLabel: "Pahalı", category: "klasik" },
  { id: "k08", leftLabel: "Kötü", rightLabel: "İyi", category: "klasik" },
  { id: "k09", leftLabel: "Ağır", rightLabel: "Hafif", category: "klasik" },
  { id: "k10", leftLabel: "Çirkin", rightLabel: "Güzel", category: "klasik" },
  { id: "k11", leftLabel: "Zayıf", rightLabel: "Güçlü", category: "klasik" },
  { id: "k12", leftLabel: "Gerçek", rightLabel: "Sahte", category: "klasik" },
  { id: "k13", leftLabel: "Doğal", rightLabel: "Yapay", category: "klasik" },
  { id: "k14", leftLabel: "Özgür", rightLabel: "Kısıtlı", category: "klasik" },
  { id: "k15", leftLabel: "Sıradan", rightLabel: "Özel", category: "klasik" },
  { id: "k16", leftLabel: "Kuru", rightLabel: "Islak", category: "klasik" },
  {
    id: "k17",
    leftLabel: "Gürültülü",
    rightLabel: "Sessiz",
    category: "klasik",
  },
  { id: "k18", leftLabel: "Geçmiş", rightLabel: "Gelecek", category: "klasik" },
  { id: "k19", leftLabel: "Sakin", rightLabel: "Enerjik", category: "klasik" },
  { id: "k20", leftLabel: "Uzak", rightLabel: "Yakın", category: "klasik" },

  // ── REKABETÇİ ────────────────────────────────────────────────────────────────
  {
    id: "r01",
    leftLabel: "Kaybedenin Şampiyonu",
    rightLabel: "Kazananın Efsanesi",
    category: "rekabetci",
  },
  {
    id: "r02",
    leftLabel: "Takım Oyuncusu",
    rightLabel: "Yıldız Oyuncu",
    category: "rekabetci",
  },
  {
    id: "r03",
    leftLabel: "Adil Oyun",
    rightLabel: "Kazanmak Her Şey",
    category: "rekabetci",
  },
  {
    id: "r04",
    leftLabel: "Amatör",
    rightLabel: "Profesyonel",
    category: "rekabetci",
  },
  {
    id: "r05",
    leftLabel: "Şanslı Başlangıç",
    rightLabel: "Çalışarak Gelinen Zirve",
    category: "rekabetci",
  },
  {
    id: "r06",
    leftLabel: "Sessiz Sedasız",
    rightLabel: "Gösteriş Gösteriş",
    category: "rekabetci",
  },
  {
    id: "r07",
    leftLabel: "Küçük Turnuva",
    rightLabel: "Dünya Şampiyonası",
    category: "rekabetci",
  },
  {
    id: "r08",
    leftLabel: "Savunmacı",
    rightLabel: "Saldırgan",
    category: "rekabetci",
  },
  {
    id: "r09",
    leftLabel: "Pratik",
    rightLabel: "Teorik",
    category: "rekabetci",
  },
  {
    id: "r10",
    leftLabel: "Sabırlı",
    rightLabel: "Sabırsız",
    category: "rekabetci",
  },
  {
    id: "r11",
    leftLabel: "Kötü Kayıp",
    rightLabel: "Onurlu Kayıp",
    category: "rekabetci",
  },
  {
    id: "r12",
    leftLabel: "Solo Güç",
    rightLabel: "Takım Gücü",
    category: "rekabetci",
  },
  {
    id: "r13",
    leftLabel: "Hazırlıksız",
    rightLabel: "Hazır",
    category: "rekabetci",
  },
  {
    id: "r14",
    leftLabel: "Düşük Beklenti",
    rightLabel: "Yüksek Beklenti",
    category: "rekabetci",
  },
  { id: "r15", leftLabel: "Keyfi", rightLabel: "Hırs", category: "rekabetci" },
  {
    id: "r16",
    leftLabel: "Zayıf Rakip",
    rightLabel: "Güçlü Rakip",
    category: "rekabetci",
  },
  {
    id: "r17",
    leftLabel: "İlk Hamle",
    rightLabel: "Son Hamle",
    category: "rekabetci",
  },
  {
    id: "r18",
    leftLabel: "Kural Kitabı",
    rightLabel: "Sezgisel Oyun",
    category: "rekabetci",
  },

  // ── SOSYAL ───────────────────────────────────────────────────────────────────
  {
    id: "s01",
    leftLabel: "İçe Dönük",
    rightLabel: "Dışa Dönük",
    category: "sosyal",
  },
  { id: "s02", leftLabel: "Utangaç", rightLabel: "Cesur", category: "sosyal" },
  {
    id: "s03",
    leftLabel: "Az Arkadaş",
    rightLabel: "Çok Arkadaş",
    category: "sosyal",
  },
  {
    id: "s04",
    leftLabel: "Dinleyen",
    rightLabel: "Konuşan",
    category: "sosyal",
  },
  {
    id: "s05",
    leftLabel: "Online İlişki",
    rightLabel: "Yüz Yüze İlişki",
    category: "sosyal",
  },
  {
    id: "s06",
    leftLabel: "Yüzeysel Sohbet",
    rightLabel: "Derin Sohbet",
    category: "sosyal",
  },
  {
    id: "s07",
    leftLabel: "Yabancı",
    rightLabel: "Eski Dost",
    category: "sosyal",
  },
  {
    id: "s08",
    leftLabel: "Sosyal Medya",
    rightLabel: "Gerçek Hayat",
    category: "sosyal",
  },
  {
    id: "s09",
    leftLabel: "Güven Vermez",
    rightLabel: "Güven Verir",
    category: "sosyal",
  },
  {
    id: "s10",
    leftLabel: "Yalnız Kurt",
    rightLabel: "Sürü Lideri",
    category: "sosyal",
  },
  {
    id: "s11",
    leftLabel: "Kısa Tanışma",
    rightLabel: "Uzun Arkadaşlık",
    category: "sosyal",
  },
  {
    id: "s12",
    leftLabel: "Çatışmacı",
    rightLabel: "Uzlaşmacı",
    category: "sosyal",
  },
  { id: "s13", leftLabel: "Bencil", rightLabel: "Fedakâr", category: "sosyal" },
  {
    id: "s14",
    leftLabel: "Soğuk İlişki",
    rightLabel: "Samimi İlişki",
    category: "sosyal",
  },
  {
    id: "s15",
    leftLabel: "Eleştirici",
    rightLabel: "Destekleyici",
    category: "sosyal",
  },
  {
    id: "s16",
    leftLabel: "Mesafeli",
    rightLabel: "Sıcakkanlı",
    category: "sosyal",
  },
  {
    id: "s17",
    leftLabel: "Hızlı Tanıdık",
    rightLabel: "Zor Isınan",
    category: "sosyal",
  },
  { id: "s18", leftLabel: "Pasif", rightLabel: "Aktif", category: "sosyal" },
];

export function getShuffledCards(categories: CategoryType[]): GameCard[] {
  const filtered =
    categories.length === 0
      ? [...ALL_CARDS]
      : ALL_CARDS.filter((c) => categories.includes(c.category));
  // Fisher-Yates shuffle
  for (let i = filtered.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [filtered[i], filtered[j]] = [filtered[j], filtered[i]];
  }
  return filtered;
}

export function getCardsByCategory(category: CategoryType): GameCard[] {
  return ALL_CARDS.filter((c) => c.category === category);
}
