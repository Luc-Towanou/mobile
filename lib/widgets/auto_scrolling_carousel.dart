// widgets/auto_scrolling_carousel.dart
import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollingCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final double height;
  final Duration scrollDuration;

  const AutoScrollingCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 280.0, // Hauteur par défaut
    this.scrollDuration = const Duration(milliseconds: 50),
  });

  @override
  State<AutoScrollingCarousel<T>> createState() => _AutoScrollingCarouselState<T>();
}

class _AutoScrollingCarouselState<T> extends State<AutoScrollingCarousel<T>> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    // Démarrer le défilement automatique après le rendu initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.scrollDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      // Si l'utilisateur touche l'écran ou si le contrôleur n'est pas attaché, on ne fait rien
      if (_isUserInteracting || !_scrollController.hasClients) return;

      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.offset;
      
      // Vitesse de défilement (pixels par tick)
      double delta = 1.0; 

      if (currentScroll >= maxScroll) {
        // Option A: Retour au début (boucle brusque)
        // _scrollController.jumpTo(0);
        
        // Option B: Retour au début en douceur (animation)
        _scrollController.animateTo(
          0, 
          duration: const Duration(milliseconds: 800), 
          curve: Curves.easeInOut
        );
      } else {
        _scrollController.jumpTo(currentScroll + delta);
      }
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => _isUserInteracting = true);
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() => _isUserInteracting = false);
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() => _isUserInteracting = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: widget.height,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(), // Permet de scroller manuellement
          itemCount: widget.items.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: widget.itemBuilder(context, widget.items[index]),
            );
          },
        ),
      ),
    );
  }
}