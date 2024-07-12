import 'package:blind_alert/models/last_voice_model.dart';
import 'package:flutter/material.dart';

class LastVoiceModelProvider with ChangeNotifier {
  late LastVoice _lastVoice;
  bool _isLoading = true;

  LastVoice get lastVoice => _lastVoice;
  bool get isLoading => _isLoading;

  void setLastVoiceModel(LastVoice lastVoice) {
    _lastVoice = lastVoice;
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
