// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:verve/views/components/animations/circular_loading_animation_view.dart';
import 'package:verve/views/components/animations/dot_loading_animation_view.dart';

class LoadingView {
  OverlayEntry? _overlayEntry;

  LoadingView._sharedInstance();
  static final LoadingView _shared = LoadingView._sharedInstance();
  factory LoadingView.instance() => _shared;

  void showLoading(BuildContext context) {
    hide();
    final renderbox = context.findRenderObject() as RenderBox;
    final size = renderbox.size;
    _overlayEntry = OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black.withAlpha(120),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            height: size.height * 0.3,
            width: size.width * 0.7,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: dotLoadingAnimationView(),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
