import 'package:ins/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:ins/app.dart' as app;

String getDocUrl(String version, String doc, String lang, String format) {
  final url =
      "https://raw.githubusercontent.com/recordbreakersorg/docs/main/ins/$version/$doc/$lang.$format";
  logger.d(url);
  return url;
}

Future<String> getTerms(String lang, String format) async {
  late http.Response response;
  try {
    response = await http.get(
      Uri.parse(getDocUrl(app.version, "terms", lang, format)),
    );
  } catch (e) {
    throw Exception("Could not get terms of service: $e");
  }
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(
      'Failed to load data from backend, invalid status code: ${response.statusCode}',
    );
  }
}
