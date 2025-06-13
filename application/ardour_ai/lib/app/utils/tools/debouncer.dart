import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = Durations.medium4});

  void run(VoidCallback action, {Duration? altDuration}) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(altDuration ?? duration, action);
  }
}
