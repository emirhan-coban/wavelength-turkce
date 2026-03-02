import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasıl Oynanır'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                icon: Icons.flag,
                title: 'Oyunun Amacı',
                description:
                    'Verilen iki zıt kavram arasında, gizli hedefin nerede olduğunu tahmin etmek. Ne kadar yaklaşırsan, o kadar çok puan kazanırsın!',
              ),
              const SizedBox(height: 24),
              _buildStep(
                step: 1,
                title: 'Oyuncuları Belirle',
                description: '2-8 oyuncu arasında seçim yap ve isimlerini gir.',
              ),
              _buildStep(
                step: 2,
                title: 'Kategori Seç',
                description:
                    'Eğlence, Maceracı, Klasik gibi kategorilerden birini seç.',
              ),
              _buildStep(
                step: 3,
                title: 'Lider Hedefi Görür',
                description:
                    'Her turda bir lider seçilir. Lider, iki zıt kavram arasında gizli hedefin nerede olduğunu görür.',
              ),
              _buildStep(
                step: 4,
                title: 'İpucu Ver',
                description:
                    'Lider, hedefin konumuna uygun bir ipucu söyler. Örneğin: "Sakin vs Enerjik" spektrumunda hedef ortaya yakınsa "Yoga" diyebilir.',
              ),
              _buildStep(
                step: 5,
                title: 'Grup Tahmin Eder',
                description:
                    'Diğer oyuncular ipucunu tartışır ve kadranı çevirerek tahminlerini yapar.',
              ),
              _buildStep(
                step: 6,
                title: 'Puanlama',
                description:
                    'Tahmin ne kadar hedefe yakınsa o kadar puan kazanılır.\n\n'
                    '🎯 Tam isabet: 50 puan\n'
                    '🔥 Çok yakın: 30 puan\n'
                    '👍 İyi: 20 puan\n'
                    '🤏 Yakın: 10 puan\n'
                    '❌ Uzak: 0 puan',
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: AppTheme.primaryOrange,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'İpucu',
                      style: TextStyle(
                        color: AppTheme.primaryOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'İyi bir ipucu, hedefin tam konumunu yansıtmalı. '
                      'Çok genel olmak yerine, spektrumdaki pozisyonu '
                      'düşünerek kelime seç!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryOrange, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int step,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
