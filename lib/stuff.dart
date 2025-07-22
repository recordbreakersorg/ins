//import 'package:flutter/foundation.dart';
const kDebugMode = true;

String stuffUrl() {
  return kDebugMode ? "http://192.168.1.192:8081" : "https://stuff.is.rbs.cm";
}

String fileUrl(int fileID) {
  return "${stuffUrl()}/file/$fileID";
}
