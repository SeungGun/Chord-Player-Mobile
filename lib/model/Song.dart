import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Song{

  final int songId;
  final String title;
  final String artist;
  final String originalKey;
  final int? bpm;
  final String? modulation;
  final String gender;
  final List<String> genres;

  Song(this.songId, this.title, this.artist, this.originalKey, this.bpm,
      this.modulation, this.gender, this.genres);

  // factory Song.fromJson(Map<String, dynamic> json) => _$Song(json);
  //
  // Map<String, dynamic> toJson() => _$Song(this);
}