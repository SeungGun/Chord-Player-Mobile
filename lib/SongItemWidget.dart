import 'package:chord_player/model/Song.dart';
import 'package:chord_player/util/PropertySongUtil.dart';
import 'package:flutter/material.dart';

class SongItemWidget extends StatefulWidget {
  const SongItemWidget({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongItemWidget> createState() => _SongItemWidgetState();
}

class _SongItemWidgetState extends State<SongItemWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print('클릭 ${widget.song.songId}');
      },
      child: Container(
        width: size.width * 0.98,
        margin: EdgeInsets.all(size.width * 0.01),
        padding: EdgeInsets.all(size.width * 0.02),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(width: 0.2, color: Colors.black),
            borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: size.width * 0.82,
                    alignment: Alignment.centerLeft,
                    child: Text(widget.song.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                  )
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Note'),
                                  content: Text(widget.song.note ?? ""),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('닫기'))
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.event_note, size: 30)))
            ],
          ),
          Row(children: [
            SizedBox(width: size.width * 0.01),
            Text(widget.song.artist,
                style: const TextStyle(color: Colors.grey, fontSize: 12))
          ]),
          SizedBox(height: size.height * 0.02),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _fieldsOfSong(
                size,
                '원키',
                _valueBox(widget.song.originalKey, size,
                    ChordUtil.getColorBySongKey(widget.song.originalKey))),
            _fieldsOfSong(
                size,
                '전조',
                _valueBox(widget.song.modulation, size,
                    ChordUtil.getColorByModulation())),
            _fieldsOfSong(
                size,
                'BPM',
                _valueBox(widget.song.bpm.toString(), size,
                    ChordUtil.getColorByBPM(widget.song.bpm!))),
            _fieldsOfSong(
                size,
                '성별',
                _valueBox(ChordUtil.convertGender(widget.song.gender), size,
                    ChordUtil.getColorByGender(widget.song.gender))),
            _fieldsOfSong(
                size,
                '장르',
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return _convertGenresToPopupMenuItems(size);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  constraints: BoxConstraints(maxWidth: size.width * 0.8),
                  padding: const EdgeInsets.all(0),
                  offset: Offset(size.width * 0.02 * -1, size.height * 0.03),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(9)),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.song.genres[0],
                                style: const TextStyle(fontSize: 12)),
                            const Icon(Icons.expand_more, size: 20),
                          ]),
                    ),
                  ),
                )),
          ]),
        ]),
      ),
    );
  }

  Column _fieldsOfSong(Size size, String fieldName, Widget belowWidget) {
    return Column(children: [
      Text(fieldName, style: const TextStyle(fontSize: 12)),
      SizedBox(height: size.height * 0.01),
      belowWidget
    ]);
  }

  Widget _valueBox(dynamic value, Size size, Map<String, Color> pair) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
          color: value == null ? Colors.transparent : pair['background'],
          borderRadius: BorderRadius.circular(11)),
      child: Text(value ?? "  ", style: TextStyle(color: pair['text'])),
    );
  }

  List<PopupMenuEntry<String>> _convertGenresToPopupMenuItems(Size size) {
    return widget.song.genres.map((String genre) {
      return PopupMenuItem<String>(
          value: genre,
          height: 25,
          padding: EdgeInsets.all(size.width * 0.01),
          child: Text(genre, style: const TextStyle(fontSize: 12)));
    }).toList();
  }
}
