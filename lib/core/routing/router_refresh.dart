import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a stream (e.g. the [SessionBloc] state stream) to a
/// [Listenable] so GoRouter can refresh its redirects when the source changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<Object?> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  StreamSubscription<Object?>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
