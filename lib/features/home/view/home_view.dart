import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/gradient_container.dart';
import '../../../core/widgets/loading_animation.dart';
import '../../../core/providers/music_provider.dart';
import '../../player/view/player_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorBoundary(
        child: GradientContainer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer<MusicProvider>(
                builder: (context, musicProvider, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildContent(context, musicProvider),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MusicProvider musicProvider) {
    switch (musicProvider.state) {
      case MusicGenerationState.loading:
        return const LoadingAnimation();
      case MusicGenerationState.playing:
        return const PlayerView();
      case MusicGenerationState.error:
        return _buildErrorView(context, musicProvider);
      default:
        return _buildIdleView(context, musicProvider);
    }
  }

  Widget _buildErrorView(BuildContext context, MusicProvider musicProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 48,
        ),
        const SizedBox(height: 16),
        Text(
          musicProvider.errorMessage ?? 'An error occurred',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => musicProvider.resetState(),
          child: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildIdleView(BuildContext context, MusicProvider musicProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Turn Your Lecture Notes into Music!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => musicProvider.processTextFile(),
          child: const Text('Upload Notes'),
        ),
        if (musicProvider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              musicProvider.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      content: child,
      leading: const SizedBox(),
      actions: const [SizedBox()],
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      forceActionsBelow: false,
    );
  }
}
