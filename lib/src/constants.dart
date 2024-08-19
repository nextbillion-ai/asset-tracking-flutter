
import 'dart:io';

class Constants {
  static final String defaultBaseUrl = Platform.isAndroid ? "https://api.nextbillion.io" : "api.nextbillion.io";
  static const int defaultDataStorageSize = 5000;
  static const int defaultDataBatchSize = 30;
  static const int defaultBatchWindow = 20;
  static const bool shouldClearLocalDataWhenCollision = true;

}