import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/room_service.dart';

class OnlineClueScreen extends StatefulWidget {
  final String roomCode;
  final Map<String, dynamic> data;

  const OnlineClueScreen({
    super.key,
    required this.roomCode,
    required this.data,
  });

  @override
  State<OnlineClueScreen> createState() => _OnlineClueScreenState();
}

class _OnlineClueScreenState extends State<OnlineClueScreen> {
  final _clueController = TextEditingController();
  bool _isSending = false;

  Future<void> _submitClue() async {
    final clue = _clueController.text.trim();
    if (clue.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await RoomService.submitClue(roomCode: widget.roomCode, clue: clue);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _clueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pair = widget.data['currentPair'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(title: const Text('İpucu Yaz')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            if (pair != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  children: [
                    const Text(
                      'KAVRAM ÇİFTİ',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pair['leftConcept'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFCD7D37),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Text(
                          '↔',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 18,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            pair['rightConcept'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'İpucunu Yaz',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hedefin konumunu temsil eden\nbir kelime veya kavram yaz',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _clueController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                hintText: 'İpucunu buraya yaz...',
                hintStyle: TextStyle(fontSize: 16),
              ),
              onSubmitted: (_) => _submitClue(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSending ? null : _submitClue,
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.background,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 18),
                        SizedBox(width: 8),
                        Text('İpucunu Gönder'),
                      ],
                    ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
