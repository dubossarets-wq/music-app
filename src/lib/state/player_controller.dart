import 'package:audio_service/audio_service.dart' show MediaItem;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();

  List<SongModel> _queue = [];
  int _currentIndex = -1;
  bool permissionGranted = false;
  bool loadingLibrary = false;

  List<SongModel> get queue => _queue;
  int get currentIndex => _currentIndex;

  SongModel? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _queue.length) ? _queue[_currentIndex] : null;

  PlayerController() {
    player.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        notifyListeners();
      }
    });
    player.playerStateStream.listen((_) => notifyListeners());
  }

  Future<bool> requestPermission() async {
    permissionGranted = await audioQuery.checkAndRequest(retryRequest: true);
    notifyListeners();
    return permissionGranted;
  }

  Future<void> loadLibrary() async {
    loadingLibrary = true;
    notifyListeners();
    _queue = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    loadingLibrary = false;
    notifyListeners();
  }

  Future<void> playFromQueue(int index) async {
    if (_queue.isEmpty) return;
    final source = ConcatenatingAudioSource(
      children: _queue
          .map((song) => AudioSource.uri(
                Uri.parse(song.uri ?? song.data),
                tag: MediaItem(
                  id: song.id.toString(),
                  title: song.title,
                  artist: song.artist ?? 'Unknown artist',
                  album: song.album ?? '',
                  duration: song.duration != null
                      ? Duration(milliseconds: song.duration!)
                      : null,
                ),
              ))
          .toList(),
    );
    await player.setAudioSource(source, initialIndex: index);
    _currentIndex = index;
    await player.play();
    notifyListeners();
  }

  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void next() => player.seekToNext();
  void previous() => player.seekToPrevious();
  void seek(Duration position) => player.seek(position);

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
