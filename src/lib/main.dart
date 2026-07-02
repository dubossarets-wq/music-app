import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'screens/library_screen.dart';
import 'state/player_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.skilletplayer.audio.channel',
    androidNotificationChannelName: 'Skillet Player playback',
    androidNotificationOngoing: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerController(),
      child: const SkilletPlayerApp(),
    ),
  );
}

class SkilletPlayerApp extends StatelessWidget {
  const SkilletPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skillet Player',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const LibraryScreen(),
    );
  }
}
