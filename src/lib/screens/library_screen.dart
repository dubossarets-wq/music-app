import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/player_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final controller = context.read<PlayerController>();
    final granted = await controller.requestPermission();
    if (granted) {
      await controller.loadLibrary();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PlayerController>();

    return Scaffold(
      appBar: AppBar(title: const Text('SKILLET PLAYER')),
      body: SafeArea(
        child: Column(
          children: [
            if (!controller.permissionGranted)
              _buildPermissionPrompt(controller)
            else ...[
              _buildSearchField(),
              Expanded(child: _buildList(controller)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }

  Widget _buildPermissionPrompt(PlayerController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 64),
            const SizedBox(height: 20),
            const Text(
              'Нужен доступ к аудиофайлам на устройстве, чтобы построить библиотеку.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _init,
              child: const Text('РАЗРЕШИТЬ ДОСТУП'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: _search,
        onChanged: (v) => setState(() => _query = v.toLowerCase()),
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Поиск по библиотеке',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildList(PlayerController controller) {
    if (controller.loadingLibrary) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }
    final songs = controller.queue
        .where((s) => _query.isEmpty || s.title.toLowerCase().contains(_query))
        .toList();

    if (songs.isEmpty) {
      return const Center(
        child: Text(
          'На устройстве не найдено аудиофайлов.\nДобавьте mp3 в память телефона.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final queueIndex = controller.queue.indexOf(song);
        final active = queueIndex == controller.currentIndex;
        return SongTile(
          song: song,
          active: active,
          onTap: () => controller.playFromQueue(queueIndex),
        );
      },
    );
  }
}
