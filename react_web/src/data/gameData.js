export const GameCategory = {
    all: [
        { id: 'eglence', name: 'Eğlence', icon: 'celebration' },
        { id: 'maceraci', name: 'Maceracı', icon: 'explore' },
        { id: 'zihin', name: 'Zihin Oyunları', icon: 'psychology' },
        { id: 'klasik', name: 'Klasik', icon: 'auto_awesome' },
        { id: 'rekabetci', name: 'Rekabetçi', icon: 'emoji_events' },
        { id: 'sosyal', name: 'Sosyal', icon: 'groups' },
    ]
};

export const SpectrumData = {
    allPairs: [
        // ─── Eğlence (Fun) ───
        { leftConcept: 'Sıkıcı', rightConcept: 'Eğlenceli', categoryId: 'eglence' },
        { leftConcept: 'Sessiz', rightConcept: 'Gürültülü', categoryId: 'eglence' },
        { leftConcept: 'Kapalı Alan', rightConcept: 'Açık Hava', categoryId: 'eglence' },
        { leftConcept: 'Tek Başına', rightConcept: 'Kalabalık', categoryId: 'eglence' },
        { leftConcept: 'Planlı Eğlence', rightConcept: 'Spontane Eğlence', categoryId: 'eglence' },
        { leftConcept: 'Film İzlemek', rightConcept: 'Dışarı Çıkmak', categoryId: 'eglence' },
        { leftConcept: 'Kitap Okumak', rightConcept: 'Parti Yapmak', categoryId: 'eglence' },
        { leftConcept: 'Sakin Akşam', rightConcept: 'Çılgın Gece', categoryId: 'eglence' },
        { leftConcept: 'Basit Oyun', rightConcept: 'Karmaşık Oyun', categoryId: 'eglence' },
        { leftConcept: 'Geleneksel', rightConcept: 'Modern', categoryId: 'eglence' },
        { leftConcept: 'Ücretsiz', rightConcept: 'Lüks', categoryId: 'eglence' },
        { leftConcept: 'Kısa Süren', rightConcept: 'Uzun Süren', categoryId: 'eglence' },

        // ─── Maceracı (Adventurous) ───
        { leftConcept: 'Güvenli', rightConcept: 'Tehlikeli', categoryId: 'maceraci' },
        { leftConcept: 'Planlı', rightConcept: 'Spontane', categoryId: 'maceraci' },
        { leftConcept: 'Şehir', rightConcept: 'Doğa', categoryId: 'maceraci' },
        { leftConcept: 'Kısa Yolculuk', rightConcept: 'Uzun Yolculuk', categoryId: 'maceraci' },
        { leftConcept: 'Konforlu', rightConcept: 'Zorlu', categoryId: 'maceraci' },
        { leftConcept: 'Tanıdık Yer', rightConcept: 'Bilinmeyen Yer', categoryId: 'maceraci' },
        { leftConcept: 'Deniz', rightConcept: 'Dağ', categoryId: 'maceraci' },
        { leftConcept: 'Yürüyüş', rightConcept: 'Koşu', categoryId: 'maceraci' },
        { leftConcept: 'Gündüz', rightConcept: 'Gece', categoryId: 'maceraci' },
        { leftConcept: 'Yerli', rightConcept: 'Yurt Dışı', categoryId: 'maceraci' },
        { leftConcept: 'Kamp', rightConcept: 'Otel', categoryId: 'maceraci' },
        { leftConcept: 'Tek Başına', rightConcept: 'Grupla', categoryId: 'maceraci' },

        // ─── Zihin Oyunları (Mind Games) ───
        { leftConcept: 'Mantık', rightConcept: 'Hayal Gücü', categoryId: 'zihin' },
        { leftConcept: 'Kolay', rightConcept: 'Zor', categoryId: 'zihin' },
        { leftConcept: 'Somut', rightConcept: 'Soyut', categoryId: 'zihin' },
        { leftConcept: 'Bilgi', rightConcept: 'Sezgi', categoryId: 'zihin' },
        { leftConcept: 'Analiz', rightConcept: 'Yaratıcılık', categoryId: 'zihin' },
        { leftConcept: 'Gerçek', rightConcept: 'Kurgu', categoryId: 'zihin' },
        { leftConcept: 'Matematik', rightConcept: 'Sanat', categoryId: 'zihin' },
        { leftConcept: 'Hafıza', rightConcept: 'Dikkat', categoryId: 'zihin' },
        { leftConcept: 'Hız', rightConcept: 'Doğruluk', categoryId: 'zihin' },
        { leftConcept: 'Basit', rightConcept: 'Karmaşık', categoryId: 'zihin' },
        { leftConcept: 'Sabır', rightConcept: 'Refleks', categoryId: 'zihin' },
        { leftConcept: 'Strateji', rightConcept: 'Şans', categoryId: 'zihin' },

        // ─── Klasik (Classic) ───
        { leftConcept: 'Sıcak', rightConcept: 'Soğuk', categoryId: 'klasik' },
        { leftConcept: 'Eski', rightConcept: 'Yeni', categoryId: 'klasik' },
        { leftConcept: 'Büyük', rightConcept: 'Küçük', categoryId: 'klasik' },
        { leftConcept: 'Hızlı', rightConcept: 'Yavaş', categoryId: 'klasik' },
        { leftConcept: 'Gündüz', rightConcept: 'Gece', categoryId: 'klasik' },
        { leftConcept: 'Yaz', rightConcept: 'Kış', categoryId: 'klasik' },
        { leftConcept: 'Tatlı', rightConcept: 'Tuzlu', categoryId: 'klasik' },
        { leftConcept: 'Yumuşak', rightConcept: 'Sert', categoryId: 'klasik' },
        { leftConcept: 'Ağır', rightConcept: 'Hafif', categoryId: 'klasik' },
        { leftConcept: 'Uzun', rightConcept: 'Kısa', categoryId: 'klasik' },
        { leftConcept: 'Açık', rightConcept: 'Koyu', categoryId: 'klasik' },
        { leftConcept: 'Geniş', rightConcept: 'Dar', categoryId: 'klasik' },

        // ─── Rekabetçi (Competitive) ───
        { leftConcept: 'Bireysel', rightConcept: 'Takım', categoryId: 'rekabetci' },
        { leftConcept: 'Güç', rightConcept: 'Strateji', categoryId: 'rekabetci' },
        { leftConcept: 'Saldırı', rightConcept: 'Savunma', categoryId: 'rekabetci' },
        { leftConcept: 'Amatör', rightConcept: 'Profesyonel', categoryId: 'rekabetci' },
        { leftConcept: 'Eğlence İçin', rightConcept: 'Kazanmak İçin', categoryId: 'rekabetci' },
        { leftConcept: 'Fiziksel', rightConcept: 'Zihinsel', categoryId: 'rekabetci' },
        { leftConcept: 'Sabırlı', rightConcept: 'Agresif', categoryId: 'rekabetci' },
        { leftConcept: 'Risk Almak', rightConcept: 'Güvenli Oynamak', categoryId: 'rekabetci' },
        { leftConcept: 'Deneyim', rightConcept: 'Yetenek', categoryId: 'rekabetci' },
        { leftConcept: 'Lider', rightConcept: 'Takipçi', categoryId: 'rekabetci' },
        { leftConcept: 'Hücum', rightConcept: 'Taktik', categoryId: 'rekabetci' },
        { leftConcept: 'Antrenman', rightConcept: 'Maç', categoryId: 'rekabetci' },

        // ─── Sosyal (Social) ───
        { leftConcept: 'İçe Dönük', rightConcept: 'Dışa Dönük', categoryId: 'sosyal' },
        { leftConcept: 'Sakin', rightConcept: 'Enerjik', categoryId: 'sosyal' },
        { leftConcept: 'Ciddi', rightConcept: 'Komik', categoryId: 'sosyal' },
        { leftConcept: 'Dinleyici', rightConcept: 'Konuşkan', categoryId: 'sosyal' },
        { leftConcept: 'Duygusal', rightConcept: 'Mantıklı', categoryId: 'sosyal' },
        { leftConcept: 'Utangaç', rightConcept: 'Cesur', categoryId: 'sosyal' },
        { leftConcept: 'Bağımsız', rightConcept: 'Bağımlı', categoryId: 'sosyal' },
        { leftConcept: 'Gelenekçi', rightConcept: 'Yenilikçi', categoryId: 'sosyal' },
        { leftConcept: 'Sabırlı', rightConcept: 'Sabırsız', categoryId: 'sosyal' },
        { leftConcept: 'İyimser', rightConcept: 'Kötümser', categoryId: 'sosyal' },
        { leftConcept: 'Romantik', rightConcept: 'Pragmatik', categoryId: 'sosyal' },
        { leftConcept: 'Alçakgönüllü', rightConcept: 'Gösterişçi', categoryId: 'sosyal' },
    ],

    getPairsForCategory: (categoryId) => {
        return SpectrumData.allPairs.filter(pair => pair.categoryId === categoryId);
    }
};
