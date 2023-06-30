import 'dart:ui';

import 'package:flutter/material.dart';

class ChordUtil {
  /*
    빨 주 노 초 파 남 보
   */
  static Map<String, Color> getColorBySongKey(String originalKey) {
    Map<String, Color> colorPair = {};
    bool isMinor = false;
    if (originalKey.contains('m')) {
      originalKey = originalKey.replaceAll('m', '');
      isMinor = true;
    }
    switch (originalKey) {
      case 'C':
        colorPair['background'] = Colors.red;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'C#':
      case 'Db':
        colorPair['background'] = Colors.deepOrangeAccent;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'D':
        colorPair['background'] = Colors.orange;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'D#':
      case 'Eb':
        colorPair['background'] = Colors.yellowAccent;
        colorPair['text'] = Colors.grey;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'E':
        colorPair['background'] = Colors.yellow;
        colorPair['text'] = Colors.black;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'F':
        colorPair['background'] = Colors.green;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'F#':
      case 'Gb':
        colorPair['background'] = Colors.blueAccent;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'G':
        colorPair['background'] = Colors.blue;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'G#':
      case 'Ab':
        colorPair['background'] = Colors.indigoAccent;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'A':
        colorPair['background'] = Colors.indigo;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'A#':
      case 'Bb':
        colorPair['background'] = Colors.deepPurpleAccent;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      case 'B':
        colorPair['background'] = Colors.purple;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
      default:
        colorPair['background'] = Colors.grey;
        colorPair['text'] = Colors.white;
        if (isMinor) {
          colorPair['background'] = colorPair['background']!.withAlpha(150);
        }
        return colorPair;
    }
  }

  static Map<String, Color> getColorByGender(String gender) {
    Map<String, Color> colorPair = {};
    switch (gender) {
      case "MALE":
        colorPair['background'] = Colors.lightBlueAccent;
        colorPair['text'] = const Color(0xFFFFFFFF);
        return colorPair;
      case "FEMALE":
        colorPair['background'] = Colors.pinkAccent;
        colorPair['text'] = const Color(0xFFFFFFFF);
        return colorPair;
      case "MIXED":
        colorPair['background'] = Colors.lightGreenAccent;
        colorPair['text'] = Colors.black;
        return colorPair;
      default:
        colorPair['background'] = Colors.grey;
        colorPair['text'] = const Color(0xFFFFFFFF);
        return colorPair;
    }
  }

  static Map<String, Color> getColorByBPM(int bpm) {
    Map<String, Color> colorPair = {};
    colorPair['text'] = Colors.black;

    if (bpm <= 60) {
      colorPair['background'] = Colors.greenAccent;
    } else if (bpm > 60 && bpm <= 90) {
      colorPair['background'] = Colors.amber;
    } else {
      colorPair['background'] = Colors.red;
    }
    return colorPair;
  }

  static String convertGender(String gender) {
    switch (gender) {
      case 'MIXED':
        return '혼성';
      case 'MALE':
        return '남';
      case 'FEMALE':
        return '여';
      default:
        return "";
    }
  }

  static Map<String, Color> getColorByModulation() {
    Map<String, Color> colorPair = {};
    colorPair['text'] = Colors.black;
    colorPair['background'] = Colors.white;
    return colorPair;
  }
}
