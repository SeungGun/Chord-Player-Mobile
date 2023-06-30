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
    return Container(
      width: size.width * 0.98,
      margin: EdgeInsets.all(size.width * 0.01),
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    width: size.width * 0.82,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.song.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.note_alt_outlined,
                        size: 30,
                      )))
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.01,
              ),
              Text(
                widget.song.artist,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('원키'),
                  SizedBox(height: size.height * 0.01),
                  _valueBox(widget.song.originalKey, size,
                      ChordUtil.getColorBySongKey(widget.song.originalKey)),
                ],
              ),
              Column(
                children: [
                  Text('전조'),
                  SizedBox(height: size.height * 0.01),
                  _valueBox(widget.song.modulation, size,
                      ChordUtil.getColorByModulation()),
                ],
              ),
              Column(
                children: [
                  Text('BPM'),
                  SizedBox(height: size.height * 0.01),
                  _valueBox(widget.song.bpm.toString(), size,
                      ChordUtil.getColorByBPM(widget.song.bpm!)),
                ],
              ),
              Column(
                children: [
                  Text('성별'),
                  SizedBox(height: size.height * 0.01),
                  _valueBox(ChordUtil.convertGender(widget.song.gender), size,
                      ChordUtil.getColorByGender(widget.song.gender)),
                ],
              ),
              Column(
                children: [
                  Text('장르'),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.025),
                    decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      widget.song.genres[0],
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                  // _valueBox(widget.song.genres.toString(), size,
                  //     ChordUtil.getColorByGender(widget.song.gender)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _valueBox(dynamic value, Size size, Map<String, Color> pair) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.025),
      decoration: BoxDecoration(
          color: value == null ? Colors.transparent : pair['background'],
          borderRadius: BorderRadius.circular(11)),
      child: Text(
        value ?? "  ",
        style: TextStyle(color: pair['text']),
      ),
    );
  }
}
