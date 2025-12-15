import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryViewerPage extends StatefulWidget {
  final String mediaUrl;
  final String description;
  final bool isVideo;

  const StoryViewerPage({
    super.key,
    required this.mediaUrl,
    required this.description,
    required this.isVideo,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  VideoPlayerController? _videoController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      )
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
            _videoController!.play();
            _videoController!.setLooping(true);
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// MEDIA
          Positioned.fill(
            child: widget.isVideo
                ? _buildVideo()
                : _buildImage(),
          ),

          /// GRADIENT + DESCRIPTION
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildDescription(),
          ),

          /// CLOSE BUTTON
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE VIEW
  Widget _buildImage() {
    return Image.network(
      widget.mediaUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          _isLoading = false;
          return child;
        }
        return _buildSkeleton();
      },
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white),
      ),
    );
  }

  /// VIDEO VIEW
  Widget _buildVideo() {
    if (_isLoading || !_videoController!.value.isInitialized) {
      return _buildSkeleton();
    }

    return VideoPlayer(_videoController!);
  }

  /// DESCRIPTION AREA
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black87,
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Text(
          widget.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  /// SKELETON LOADER
  Widget _buildSkeleton() {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
