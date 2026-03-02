import 'package:flutter/material.dart';

class GameCategory {
  final String id;
  final String name;
  final IconData icon;

  const GameCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<GameCategory> all = [
    GameCategory(id: 'eglence', name: 'Eğlence', icon: Icons.celebration),
    GameCategory(id: 'maceraci', name: 'Maceracı', icon: Icons.explore),
    GameCategory(id: 'zihin', name: 'Zihin Oyunları', icon: Icons.psychology),
    GameCategory(id: 'klasik', name: 'Klasik', icon: Icons.auto_awesome),
    GameCategory(id: 'rekabetci', name: 'Rekabetçi', icon: Icons.emoji_events),
    GameCategory(id: 'sosyal', name: 'Sosyal', icon: Icons.groups),
  ];
}
