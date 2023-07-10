import 'package:chord_player/util/APIUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CreateSongPage extends StatefulWidget {
  const CreateSongPage({Key? key}) : super(key: key);

  @override
  State<CreateSongPage> createState() => _CreateSongPageState();
}

class _CreateSongPageState extends State<CreateSongPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _bpmController = TextEditingController();
  final TextEditingController _modulationController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _initModulationController =
      TextEditingController();

  int _selectedRadio = 1;

  List<Widget> _modulationWidgetList = [];
  List<TextEditingController> _modulationControllerList = [];

  List<String> _genreList = [];
  List<String> selectedItems = [];

  Future<void> _getGenreList() async {
    String url = '${APIUtil.API_URL}/genres';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedResponseJson2 =
          APIUtil.decodedResponseListJson(response.bodyBytes);

      setState(() {
        _genreList.addAll(
            decodedResponseJson2.map((e) => e['genreName'] as String).toList());
      });
    }
  }

  setSelectedRadio(int val) {
    setState(() {
      _selectedRadio = val;
    });
  }

  @override
  void initState() {
    _getGenreList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '노래 악보 생성하기',
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '기본 노래 정보',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text('* 제목'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(9)),
                    child: TextField(
                      style: TextStyle(fontSize: 13),
                      controller: _titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.music_note),
                          hintText: "노래 제목을 입력하세요.",
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text('* 가수'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(9)),
                    child: TextField(
                      controller: _artistController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.mic),
                          hintText: "가수(아티스트)를 입력하세요.",
                          hintStyle:
                              TextStyle(fontSize: 13, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text('* 원키'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.2),
                        borderRadius: BorderRadius.circular(9)),
                    child: TextField(
                      onChanged: (value) {
                        _initModulationController.text = value;
                      },
                      style: TextStyle(fontSize: 13),
                      controller: _keyController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text('* 성별'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setSelectedRadio(1);
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _selectedRadio,
                          onChanged: (val) {
                            setSelectedRadio(val!);
                          },
                        ),
                        Text('남'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setSelectedRadio(2);
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _selectedRadio,
                          onChanged: (val) {
                            setSelectedRadio(val!);
                          },
                        ),
                        Text('여'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setSelectedRadio(3);
                    },
                    child: Row(
                      children: [
                        Radio(
                          value: 3,
                          groupValue: _selectedRadio,
                          onChanged: (val) {
                            setSelectedRadio(val!);
                          },
                        ),
                        Text('혼성'),
                      ],
                    ),
                  ),
                ],
              ),
              Text('BPM'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width * 0.25,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.2),
                    borderRadius: BorderRadius.circular(9)),
                child: TextField(
                  controller: _bpmController,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  style: TextStyle(fontSize: 13),
                  buildCounter: (BuildContext context,
                          {required int currentLength,
                          int? maxLength,
                          required bool isFocused}) =>
                      null,
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text('전조(키 변경)'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.12,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _initModulationController,
                      readOnly: true,
                      decoration: InputDecoration(border: InputBorder.none),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Row(
                    children: _modulationWidgetList,
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        if (_keyController.text.isNotEmpty &&
                            _modulationControllerList.length < 4) {
                          _modulationControllerList
                              .add(TextEditingController());
                          _modulationWidgetList.add(_keyBox(
                              size, _modulationControllerList.length - 1));
                        }
                      });
                    },
                    constraints: BoxConstraints.tightFor(
                        width: size.width * 0.07, height: size.width * 0.07),
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    fillColor: Colors.blue,
                  )
                ],
              ),
              Text('* 장르'),
              TextButton(
                  onPressed: () async {
                    List<String>? items = await showDialog<List<String>>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('장르 선택'),
                          content:
                              StatefulBuilder(builder: (context, setState) {
                            return SingleChildScrollView(
                              child: Column(
                                children: _genreList.map((item) {
                                  bool isSelected =
                                      selectedItems.contains(item);
                                  return CheckboxListTile(
                                    title: Text(item),
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (isSelected) {
                                          selectedItems.remove(item);
                                        } else {
                                          selectedItems.add(item);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                          actions: <Widget>[
                            TextButton(
                              child: Text('닫기'),
                              onPressed: () {
                                Navigator.of(context).pop(selectedItems);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      if (selectedItems != null) {}
                    });
                  },
                  child: Text('장르 목록 불러오기')),
              Column(
                children: _genreWidgetList(selectedItems),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text('메모'),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.all(size.width * 0.01),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.2),
                    borderRadius: BorderRadius.circular(9)),
                child: TextField(
                  controller: _memoController,
                  style: TextStyle(fontSize: 13),
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "필요에 따라 노래에 대한 자신의 메모를 작성하세요.",
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Divider(
                color: Colors.black45,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                '가사 및 코드 정보',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keyBox(Size size, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      width: size.width * 0.12,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(9),
          color: Colors.white),
      child: TextField(
        controller: _modulationControllerList[index],
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  List<Widget> _genreWidgetList(List<String> list) {
    return list.map((e) => Text(e)).toList();
  }
}
