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
  String _currentKey = '없음';
  String _currentCriteria = '제목';
  String _currentSort = '시간순';
  String _currentGender = '없음';
  String _currentGenre = '없음';

  final _keyList = [
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
  final _criteriaList = ['제목', '가수'];
  final _sortList = ['시간순', '이름순', '조회순'];
  final _genderList = ['없음', '남자', '여자', '혼성'];
  final List<String> _genreList = ['없음'];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _songListController = ScrollController();
  final List<Song> _songList = [];

  bool _isLoaded = false;
  String? criteriaParam;
  String? genderParam;
  String? sortParam;

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

  Future<void> _getSongList(
      int current,
      int size,
      String? criteria,
      String? keyword,
      String? gender,
      String? key,
      String? genre,
      String? sort) async {
    _isLoaded = false;
    String url = '${APIUtil.API_URL}/songs';

    String c = criteria == null ? "" : '&searchCriteria=$criteria';
    String kw = (keyword == null || keyword.isEmpty) ? "" : '&keyword=$keyword';
    String gd = (gender == null || gender == '없음') ? "" : '&gender=$gender';
    String k = (key == null || key == '없음') ? "" : '&key=$key';
    String g = (genre == null || genre == '없음') ? "" : '&genre=$genre';
    String s = sort == null ? "" : '&sort=$sort';

    final response = await http
        .get(Uri.parse('$url?page=$current&size=$size$c$kw$gd$k$g$s'));
    if (response.statusCode == 200) {
      var decodedJson = APIUtil.decodedResponseListJson(response.bodyBytes);
      setState(() {
        if (decodedJson.isNotEmpty) {
          for (int i = 0; i < decodedJson.length; ++i) {
            _songList.add(Song.fromJson(decodedJson[i]));
          }
        }
        _isLoaded = true;
      });
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    _getGenreList();
    _getSongList(0, 10, null, null, null, null, null, null);

    _songListController.addListener(() async {
      if (_songListController.position.maxScrollExtent ==
          _songListController.position.pixels) {
        await _getSongList(
            _songList[_sortList.length - 1].songId,
            10,
            criteriaParam,
            _searchController.text,
            genderParam,
            _currentKey,
            _currentGenre,
            sortParam);
      }
    });
    super.initState();
  }

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
                  SizedBox(width: size.width * 0.015),
                  const Icon(Icons.queue_music, size: 46),
                  SizedBox(width: size.width * 0.03),
                  Container(
                    width: size.width * 0.75,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300]),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
            Divider(
                height: size.height * 0.005,
                thickness: 0.5,
                color: Colors.black),
            SizedBox(height: size.height * 0.01),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterLayout(size, '키', _currentKey, () {
                    _showFilterDialog(size, 'Key', _keyList);
                  }),
                  _filterLayout(size, '장르', _currentGenre, () {
                    _showFilterDialog(size, '장르', _genreList);
                  }),
                  _filterLayout(size, '검색 기준', _currentCriteria, () {
                    _showFilterDialog(size, '검색 기준', _criteriaList);
                  }),
                  _filterLayout(size, '정렬 기준', _currentSort, () {
                    _showFilterDialog(size, '정렬 기준', _sortList);
                  }),
                  _filterLayout(size, '성별', _currentGender, () {
                    _showFilterDialog(size, '성별', _genderList);
                  }),
                ],
              ),
            ),
            _isLoaded
                ? _songList.isEmpty
                    ? const Expanded(
                        child: Center(
                        child: Text('노래 목록이 없습니다!',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ))
                    : Expanded(
                        child: RefreshIndicator(
                        onRefresh: () async {
                          await _getSongList(
                              0,
                              10,
                              criteriaParam,
                              _searchController.text,
                              genderParam,
                              _currentKey,
                              _currentGenre,
                              sortParam);
                        },
                        child: ListView.builder(
                            controller: _songListController,
                            itemBuilder: (context, index) =>
                                SongItemWidget(song: _songList[index]),
                            itemCount: _songList.length,
                            shrinkWrap: true),
                      ))
                : Expanded(
                    child: RefreshIndicator(
                        onRefresh: () async {},
                        child:
                            const Center(child: CircularProgressIndicator())))
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$title: ',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                Text(value,
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            (value == '없음' || value == '제목' || value == '시간순')
                                ? Colors.black
                                : Colors.green))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(Size size, String title, List filterList) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('검색 필터링 - $title'),
            content: SizedBox(
              width: double.maxFinite,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filterList[index]),
                        onTap: () {
                          setState(() {
                            switch (title) {
                              case 'Key':
                                _currentKey = filterList[index];
                                break;
                              case '장르':
                                _currentGenre = filterList[index];
                                break;
                              case '검색 기준':
                                _currentCriteria = filterList[index];
                                switch (_currentCriteria) {
                                  case '제목':
                                    criteriaParam = 'TITLE';
                                    break;
                                  case '가수':
                                    criteriaParam = 'ARTIST';
                                    break;
                                  default:
                                    criteriaParam = null;
                                }
                                break;
                              case '정렬 기준':
                                _currentSort = filterList[index];
                                switch (_currentSort) {
                                  case '시간순':
                                    sortParam = 'CHRONOLOGICAL';
                                    break;
                                  case '이름순':
                                    sortParam = 'NAME';
                                    break;
                                  case '조회순':
                                    sortParam = 'VIEW';
                                    break;
                                  default:
                                    sortParam = null;
                                }
                                break;
                              case '성별':
                                _currentGender = filterList[index];
                                switch (_currentGender) {
                                  case '남자':
                                    genderParam = 'MALE';
                                    break;
                                  case '여자':
                                    genderParam = 'FEMALE';
                                    break;
                                  case '혼성':
                                    genderParam = 'MIXED';
                                    break;
                                  default:
                                    genderParam = null;
                                }
                            }
                          });
                          setState(() {
                            _songList.clear();
                            _getSongList(
                                0,
                                10,
                                criteriaParam,
                                _searchController.text,
                                genderParam,
                                _currentKey,
                                _currentGenre,
                                sortParam);
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
              ),
            )));
  }
}
