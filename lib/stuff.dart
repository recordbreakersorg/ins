import 'package:flutter/foundation.dart';

String stuffUrl() {
  return kDebugMode ? "https://stuff.is.rbs.cm" : "http://192.168.1.192:8081";
}

String fileUrl(int fileID) {
  return "${stuffUrl()}/file/$fileID";
}
