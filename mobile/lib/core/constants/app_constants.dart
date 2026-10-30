import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class AppConstants {
  static const String appName =
      'CheaFood';

  static String get baseUrl {
    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  /// Base URL untuk file yang diunggah (storage Laravel).
  /// Diambil dari [baseUrl] dengan menghilangkan '/api' lalu menambah '/storage'.
  /// Contoh: http://10.0.2.2:8000/storage
  static String get imageBaseUrl {
    return baseUrl.replaceFirst(RegExp(r'/api$'), '') + '/storage';
  }
}
