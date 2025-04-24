import 'package:flutter/foundation.dart';
import '../services/file_service.dart';
import '../services/mubert_service.dart';

enum MusicGenerationState { idle, loading, playing, error }

class MusicProvider extends ChangeNotifier {
  final FileService _fileService = FileService();
  final MubertService _mubertService = MubertService();
  
  MusicGenerationState _state = MusicGenerationState.idle;
  String? _currentTrackUrl;
  String? _errorMessage;
  bool _isInitialized = false;

  MusicGenerationState get state => _state;
  String? get currentTrackUrl => _currentTrackUrl;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isInitialized = false;
    super.dispose();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // Add any necessary initialization here
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Initialization error: $e');
      }
      _errorMessage = 'Failed to initialize app';
      _state = MusicGenerationState.error;
      notifyListeners();
    }
  }

  Future<void> processTextFile() async {
    if (!_isInitialized) await initialize();
    
    try {
      _state = MusicGenerationState.loading;
      _errorMessage = null;
      notifyListeners();

      final text = await _fileService.pickAndReadTextFile();
      if (text == null || text.isEmpty) {
        throw Exception('No file selected or file is empty');
      }

      _currentTrackUrl = await _mubertService.generateMusic(text);
      _state = MusicGenerationState.playing;
    } catch (e) {
      if (kDebugMode) {
        print('Process error: $e');
      }
      _state = MusicGenerationState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = MusicGenerationState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
