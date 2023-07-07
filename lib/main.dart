import 'package:chord_player/util/APIUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'SongListPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  APIUtil.API_URL = dotenv.env['api_url'] ?? "";
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SongListPage(),
  ));
}
