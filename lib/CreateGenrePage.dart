import 'dart:convert';

import 'package:chord_player/util/APIUtil.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CreateGenrePage extends StatefulWidget {
  const CreateGenrePage({Key? key}) : super(key: key);

  @override
  State<CreateGenrePage> createState() => _CreateGenrePageState();
}

class _CreateGenrePageState extends State<CreateGenrePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _createNewGenre(String name) async {
    String url = '${APIUtil.API_URL}/genres';

    Map<String, dynamic> body = {'name': name};

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body),
        headers: <String, String>{'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      _showToast('장르 생성이 완료되었습니다!');
      _terminateScreen();
    } else {
      try {
        var errorJson = APIUtil.decodedResponseJson(response.bodyBytes);
        if (errorJson['errorCode'] == '4004') {
          _showToast('$name은 이미 존재하는 장르입니다.');
        }
      } catch (e) {
        _showToast('장르를 생성하는데 예기치 못한 문제가 발생했습니다.');
      }
    }
  }

  void _terminateScreen() {
    Navigator.pop(context, true);
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('장르 생성하기',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          backgroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(9)),
                    child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: _nameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.masks_outlined),
                            hintText: "장르 명을 입력하세요.",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey))),
                  ),
                  Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: const Text('※ 장르 명은 중복될 수 없습니다.',
                          style: TextStyle(fontSize: 12, color: Colors.red))),
                  Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: const Text('※ 장르는 노래가 갖는 분위기, 일반적인 장르 모두 포함합니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.red))),
                ],
              ),
            ),
          ),
          Container(
              width: size.width,
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: TextButton(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.compact),
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
                      _showToast('이름을 입력하세요!');
                      return;
                    }
                    await _createNewGenre(_nameController.text);
                  },
                  child: const Text('저장하기',
                      style: TextStyle(color: Colors.white, fontSize: 13))))
        ],
      ),
    );
  }
}
