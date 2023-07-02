import 'package:chord_player/SongItemWidget.dart';
import 'package:chord_player/util/APIUtil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CreateSongPage.dart';
import 'component/ActionButton.dart';
import 'component/Expandable.dart';
import 'model/Song.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({Key? key}) : super(key: key);

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  Song song = Song(1, "나를 사랑했던 사람아", "허각", "B", 63, null, "MALE", ["발라드"]);

  String _currentKey = '없음';
  String _currentCriteria = '제목';
  String _currentSort = '시간순';
  String _currentGender = '없음';
  String _currentGenre = '없음';

  final keyList = [
    '없음',
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
  final criteriaList = ['제목', '가수'];
  final sortList = ['시간순', '이름순', '조회순'];
  final genderList = ['없음', '남자', '여자', '혼성'];
  final TextEditingController _searchController = TextEditingController();

  // Future<List<String>> _getGenreList() async{
  //   final response = await http.get(Uri.parse('${APIUtil.API_HOST}/genres'));
  //
  //   if(response.statusCode == 200){
  //
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              width: size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.015,
                  ),
                  Icon(
                    Icons.queue_music,
                    size: 46,
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Container(
                    width: size.width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: size.height * 0.005,
              thickness: 0.5,
              color: Colors.black,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterLayout(size, '키', _currentKey, () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text('검색 필터링 - Key'),
                            content: Container(
                              width: double.maxFinite,
                              height: size.height * 0.5,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: keyList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(keyList[index]),
                                        onTap: () {
                                          setState(() {
                                            _currentKey = keyList[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }),
                              ),
                            )));
                  }),
                  _filterLayout(size, '장르', _currentGenre, () {}),
                  _filterLayout(size, '검색 기준', _currentCriteria, () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text('검색 필터링 - 검색 기준'),
                            content: Container(
                              width: double.maxFinite,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: criteriaList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(criteriaList[index]),
                                        onTap: () {
                                          setState(() {
                                            _currentCriteria =
                                                criteriaList[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }),
                              ),
                            )));
                  }),
                  _filterLayout(size, '정렬 기준', _currentSort, () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text('검색 필터링 - 정렬 기준'),
                            content: Container(
                              width: double.maxFinite,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: sortList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(sortList[index]),
                                        onTap: () {
                                          setState(() {
                                            _currentSort = sortList[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }),
                              ),
                            )));
                  }),
                  _filterLayout(size, '성별', _currentGender, () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text('검색 필터링 - 성별'),
                            content: Container(
                              width: double.maxFinite,
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: genderList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(genderList[index]),
                                        onTap: () {
                                          setState(() {
                                            _currentGender = genderList[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }),
                              ),
                            )));
                  }),
                ],
              ),
            ),
            SongItemWidget(song: song)
          ],
        ),
        floatingActionButton: Expandable(
          distance: 70,
          children: [
            ActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateSongPage()));
                },
                icon: const Icon(Icons.music_note)),
            // 노래 추가
            ActionButton(onPressed: () {}, icon: const Icon(Icons.masks))
            // 장르 추가
          ],
        ),
      ),
    );
  }

  Widget _filterLayout(
      Size size, String title, String value, void Function()? clickEvent) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.01),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: clickEvent,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            padding: EdgeInsets.all(size.width * 0.015),
            child: Row(
              children: [
                Text(
                  '$title: ',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 13,
                      color: (value == '없음' || value == '제목' || value == '시간순')
                          ? Colors.black
                          : Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
