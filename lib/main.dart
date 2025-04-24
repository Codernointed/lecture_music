import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/music_provider.dart';
import 'features/home/view/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('Flutter Error: ${details.toString()}');
    }
  };

  runApp(const MusicLectureApp());
}

class MusicLectureApp extends StatelessWidget {
  const MusicLectureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: MaterialApp(
        title: 'Lecture Music',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomeView(),
      ),
    );
  }
}
