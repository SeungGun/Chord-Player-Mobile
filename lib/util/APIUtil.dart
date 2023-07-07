import 'dart:convert';
import 'dart:typed_data';

class APIUtil {
  static String API_URL = "";

  static Map decodedResponseJson(Uint8List body) => jsonDecode(utf8.decode(body));
  static List<dynamic> decodedResponseListJson(Uint8List body) => jsonDecode(utf8.decode(body));
}
