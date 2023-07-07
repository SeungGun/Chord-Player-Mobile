class Song {
  final int songId;
  final String title;
  final String artist;
  final String originalKey;
  final int? bpm;
  final String? modulation;
  final String gender;
  final String? note;
  final List<String> genres;

  Song(this.songId, this.title, this.artist, this.originalKey, this.bpm,
      this.modulation, this.gender, this.note, this.genres);

  Song.fromJson(Map<String, dynamic> json)
      : songId = json['songId'],
        title = json['title'],
        artist = json['artist'],
        originalKey = json['originalKey'],
        bpm = json['bpm'],
        modulation = json['modulation'],
        gender = json['gender'],
        note = json['note'],
        genres = List<String>.from(json['genres'].map((item) => item.toString()).toList());
}
