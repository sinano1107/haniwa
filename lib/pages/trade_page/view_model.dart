import 'package:flutter/foundation.dart';
import 'package:confetti/confetti.dart';

class TradeViewModel extends ChangeNotifier {
  final _controller = ConfettiController(duration: Duration(seconds: 10));
  ConfettiController get controller => _controller;
}
