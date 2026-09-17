import 'package:flutter/widgets.dart';

typedef KeyboardHeightCallback = void Function(double height);

class KeyboardHeightObserver with WidgetsBindingObserver {
  KeyboardHeightObserver._() {
    WidgetsBinding.instance.addObserver(this);
    _updateHeight();
  }

  static final KeyboardHeightObserver instance = KeyboardHeightObserver._();
  static double currentKeyboardHeight = 0;
  static int androidSDKVersion = -1;

  final List<KeyboardHeightCallback> _listeners = [];

  void addListener(KeyboardHeightCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(KeyboardHeightCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _updateHeight() {
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view == null) return;
    final bottom = view.viewInsets.bottom;
    final pixelRatio = view.devicePixelRatio;
    final height = pixelRatio > 0 ? (bottom / pixelRatio) : bottom;
    if (height != currentKeyboardHeight) {
      currentKeyboardHeight = height;
      notify(height);
    }
  }

  @override
  void didChangeMetrics() {
    _updateHeight();
  }

  void notify(double height) {
    for (final listener in List.of(_listeners)) {
      listener(height);
    }
  }
}
