import 'package:chord_player/SongItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  final TextEditingController _searchController = TextEditingController();

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
                    width: size.width * 0.02,
                  ),
                  Icon(
                    Icons.queue_music,
                    size: 48,
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Container(
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueAccent[100],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  Container(
                    child: Text('키: ${_currentKey}', style: TextStyle(fontSize: 13),),
                    padding: EdgeInsets.all(size.width * 0.01),
                    margin: EdgeInsets.all(size.width * 0.01),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                    ),
                  ), // 키
                  Container(
                    child: Text('성별: ${_currentGender}', style: TextStyle(fontSize: 13)),
                    padding: EdgeInsets.all(size.width * 0.01),
                    margin: EdgeInsets.all(size.width * 0.01),

                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                  ), // 성별
                  Container(
                    child: Text('장르: ${_currentGenre}', style: TextStyle(fontSize: 13)),
                    padding: EdgeInsets.all(size.width * 0.01),
                    margin: EdgeInsets.all(size.width * 0.01),

                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                  ), // 장르
                  Container(
                    child: Text('검색기준: ${_currentCriteria}', style: TextStyle(fontSize: 13)),
                    padding: EdgeInsets.all(size.width * 0.01),
                    margin: EdgeInsets.all(size.width * 0.01),

                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                  ), // 검색 기준
                  Container(
                    child: Text('정렬: ${_currentSort}', style: TextStyle(fontSize: 13)),
                    padding: EdgeInsets.all(size.width * 0.01),
                    margin: EdgeInsets.all(size.width * 0.01),

                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                  ), // 정렬 기준
                ],
              ),
            ),
            SongItemWidget(song: song)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
