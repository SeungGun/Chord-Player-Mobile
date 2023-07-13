import 'dart:async';

import 'package:chord_player/util/APIUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _initModController = TextEditingController();
  final List<Widget> _modulationWidgetList = [];
  final List<List<Widget>> _chordsWidgetList = [];
  final List<StreamController<List>> _streamControllerList = [];
  final List<Widget> _lineWidgetList = [];
  final List<TextEditingController> _modulationControllerList = [];
  final List<List<TextEditingController>> _chordControllerList = [];
  final List<TextEditingController> _lyricsControllerList = [];
  final List<String> _genreList = [];
  final List<String> _selectedItems = [];
  final List<String> _selectedTagList = [];
  final StreamController<String> _selectedTagController =
      StreamController<String>.broadcast();
  final _tagList = [
    'Intro',
    'Verse',
    'Chorus',
    'Interlude',
    'Modulation',
    'Bridge',
    'Outro'
  ];
  final _keyList = [
    'C',
    'Cm',
    'C#',
    'C#m',
    'Db',
    'Dbm',
    'E',
    'Em',
    'F',
    'Fm',
    'F#',
    'F#m',
    'Gb',
    'Gbm',
    'G',
    'Gm',
    'G#',
    'G#m',
    'Ab',
    'Abm',
    'A',
    'Am',
    'A#',
    'A#m',
    'Bb',
    'Bbm',
    'B',
    'Bm'
  ];
  String _selectedKey = '';
  int _selectedRadio = 1;

  Future<void> _getGenreList() async {
    String url = '${APIUtil.API_URL}/genres';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedJson = APIUtil.decodedResponseListJson(response.bodyBytes);

      setState(() {
        _genreList
            .addAll(decodedJson.map((e) => e['genreName'] as String).toList());
      });
    }
  }

  Future<void> _registerNewSongWithLyricsAndChords() async {}

  void _setSelectedRadio(int val) {
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
          title: const Text('노래 악보 생성하기',
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('기본 노래 정보',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: size.height * 0.03),
                    const Text('* 제목', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
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
                            style: const TextStyle(fontSize: 13),
                            controller: _titleController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.music_note),
                                hintText: "노래 제목을 입력하세요.",
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text('* 가수', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
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
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.mic),
                                hintText: "가수(아티스트)를 입력하세요.",
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text('* 원키', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(width: 0.2),
                              borderRadius: BorderRadius.circular(9)),
                          child: TextField(
                            onTap: () async {
                              var value = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      title: Text('키 목록'),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: ScrollConfiguration(
                                          behavior: const ScrollBehavior()
                                              .copyWith(overscroll: false),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _keyList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(_keyList[index]),
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedKey =
                                                          _keyList[index];
                                                    });
                                                    Navigator.pop(
                                                        context, _selectedKey);
                                                  },
                                                );
                                              }),
                                        ),
                                      )));
                              setState(() {
                                _keyController.text = value;
                                _initModController.text = value;
                              });
                            },
                            readOnly: true,
                            style: TextStyle(fontSize: 13),
                            controller: _keyController,
                            textAlign: TextAlign.center,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text('* 성별', style: TextStyle(fontSize: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _setSelectedRadio(1);
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _selectedRadio,
                                onChanged: (val) {
                                  _setSelectedRadio(val!);
                                },
                              ),
                              Text('남', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _setSelectedRadio(2);
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: _selectedRadio,
                                onChanged: (val) {
                                  _setSelectedRadio(val!);
                                },
                              ),
                              Text('여', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _setSelectedRadio(3);
                          },
                          child: Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: _selectedRadio,
                                onChanged: (val) {
                                  _setSelectedRadio(val!);
                                },
                              ),
                              Text('혼성', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text('BPM', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
                    Container(
                      width: size.width * 0.2,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Divider(),
                    Text('전조', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.12,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.white),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _initModController,
                            readOnly: true,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        Row(children: _modulationWidgetList),
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              if (_keyController.text.isNotEmpty) {
                                if (_modulationControllerList.length < 4) {
                                  _modulationControllerList
                                      .add(TextEditingController());
                                  _modulationWidgetList.add(_keyBox(size,
                                      _modulationControllerList.length - 1));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: '전조는 최대 4개까지 입력 가능합니다.');
                                }
                              } else {
                                Fluttertoast.showToast(msg: '원키를 먼저 입력해주세요!');
                              }
                            });
                          },
                          constraints: BoxConstraints.tightFor(
                              width: size.width * 0.07,
                              height: size.width * 0.07),
                          shape: CircleBorder(),
                          child: Icon(Icons.add, size: 20, color: Colors.white),
                          fillColor: Colors.blue,
                        )
                      ],
                    ),
                    Divider(),
                    Text('* 장르', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
                    Container(
                      width: size.width * 0.33,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.8),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9)),
                      child: TextButton(
                          style:
                              ButtonStyle(visualDensity: VisualDensity.compact),
                          onPressed: () async {
                            List<String>? items =
                                await showDialog<List<String>>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('장르 선택(복수 선택)'),
                                  content: StatefulBuilder(
                                      builder: (context, setState) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: _genreList.map((item) {
                                          bool isSelected =
                                              _selectedItems.contains(item);
                                          return CheckboxListTile(
                                            title: Text(item),
                                            value: isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                if (isSelected) {
                                                  _selectedItems.remove(item);
                                                } else {
                                                  _selectedItems.add(item);
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
                                        Navigator.of(context)
                                            .pop(_selectedItems);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {
                              if (_selectedItems != null) {}
                            });
                          },
                          child:
                              Text('장르 선택하기', style: TextStyle(fontSize: 12))),
                    ),
                    _selectedItems.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: const Text('※ 선택된 장르 목록',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          )
                        : SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _genreWidgetList(size, _selectedItems),
                    ),
                    Divider(),
                    Text('메모', style: TextStyle(fontSize: 12)),
                    SizedBox(height: size.height * 0.012),
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
                          maxLines: 4,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "필요에 따라 노래에 대한 자신의 메모를 작성하세요.",
                              hintStyle:
                                  TextStyle(fontSize: 13, color: Colors.grey)),
                        )),
                    SizedBox(height: size.height * 0.012),
                    const Divider(color: Colors.black45),
                    SizedBox(height: size.height * 0.012),
                    const Text('가사 및 코드 정보',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.01),
                      child: const Text(
                          '※ 마디 별로 코드와 가사를 입력합니다. 코드는 우측 초록색 버튼으로 추가가 가능하고, 가사는 하단 입력창에 입력합니다.',
                          style: TextStyle(fontSize: 10, color: Colors.red)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.01),
                      child: const Text(
                          '※ 현재 마디의 태그를 지정합니다. 왼쪽 버튼으로 현재 마디의 음악적 구성이 무엇인지 선택합니다.',
                          style: TextStyle(fontSize: 10, color: Colors.red)),
                    ),
                    Column(children: _lineWidgetList),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.7,
                          height: size.height * 0.04,
                          margin: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            style: const ButtonStyle(
                                visualDensity: VisualDensity.compact),
                            child:
                                Icon(Icons.add, size: 20, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _chordsWidgetList.add([]);
                                _chordControllerList.add([]);
                                _selectedTagList.add('Verse');
                                _lyricsControllerList
                                    .add(TextEditingController());
                                _streamControllerList
                                    .add(StreamController.broadcast());
                                _lineWidgetList.add(_lineItemWidget(
                                    size, _lineWidgetList.length));
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: size.width,
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: TextButton(
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  onPressed: () {},
                  child: Text('저장하기',
                      style: TextStyle(color: Colors.white, fontSize: 13))))
        ],
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

  List<Widget> _genreWidgetList(Size size, List<String> list) {
    return list
        .map((e) => Container(
            width: size.width * 0.18,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.1)),
            padding: EdgeInsets.all(size.width * 0.02),
            margin: EdgeInsets.all(size.width * 0.005),
            child: Text('- $e', style: const TextStyle(fontSize: 12))))
        .toList();
  }

  Widget _keyBoxInChord(Size size, int outerIndex, int innerIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.005),
      width: size.width * 0.11,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 0.3),
          borderRadius: BorderRadius.circular(7),
          color: Colors.white),
      child: TextField(
        controller: _chordControllerList[outerIndex][innerIndex],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
        buildCounter: (BuildContext context,
                {required int currentLength,
                int? maxLength,
                required bool isFocused}) =>
            null,
        maxLength: 3,
        decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            constraints: BoxConstraints(maxHeight: size.height * 0.06)),
      ),
    );
  }

  Widget _lineItemWidget(Size size, int index) {
    return Container(
      height: size.height * 0.13,
      margin: EdgeInsets.all(size.width * 0.01),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[100]),
      child: Row(
        children: [
          Container(
            width: size.width * 0.1,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('#${index + 1}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(width: 1, color: Colors.red),
                        color: Colors.white),
                    child: TextButton(
                      onPressed: () async {
                        var value = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('${index + 1}번째 마디 태그 설정'),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior()
                                          .copyWith(overscroll: false),
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(_tagList[index]),
                                            onTap: () {
                                              Navigator.pop(
                                                  context, _tagList[index]);
                                            },
                                          );
                                        },
                                        itemCount: _tagList.length,
                                        shrinkWrap: true,
                                      ),
                                    ),
                                  ),
                                ));
                        setState(() {
                          _selectedTagList[index] = value;
                          _selectedTagController.add(_selectedTagList[index]);
                        });
                      },
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.compact),
                      child: StreamBuilder<String>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var c = snapshot.data!.characters;
                            return Text(
                                '${c.characterAt(0).toString()}${c.characterAt(c.length - 1).toString()}',
                                style: const TextStyle(fontSize: 12));
                          } else {
                            return const SizedBox();
                          }
                        },
                        initialData: _selectedTagList[index],
                        stream: _selectedTagController.stream,
                      ),
                    )),
              ],
            ),
          ),
          const VerticalDivider(endIndent: 5, indent: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StreamBuilder<List>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: snapshot.data as List<Widget>);
                            } else {
                              return const SizedBox();
                            }
                          },
                          stream: _streamControllerList[index].stream),
                    ),
                    RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            if (_chordControllerList[index].length < 5) {
                              _chordControllerList[index]
                                  .add(TextEditingController());
                              _chordsWidgetList[index].add(_keyBoxInChord(
                                  size,
                                  index,
                                  _chordControllerList[index].length - 1));
                              _streamControllerList[index]
                                  .add(_chordsWidgetList[index]);
                            } else {
                              Fluttertoast.showToast(
                                  msg: '현재 코드는 5개까지 추가 가능합니다.');
                            }
                          });
                        },
                        constraints: BoxConstraints.tightFor(
                            width: size.width * 0.07,
                            height: size.width * 0.07),
                        shape: const CircleBorder(),
                        fillColor: Colors.lightGreen,
                        child: const Icon(Icons.add,
                            size: 20, color: Colors.white))
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(size.width * 0.007),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2),
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.white),
                  width: size.width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        constraints:
                            BoxConstraints(maxHeight: size.height * 0.06)),
                    controller: _lyricsControllerList[index],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
