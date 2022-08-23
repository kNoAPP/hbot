import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'h_bot_data.freezed.dart';
part 'h_bot_data.g.dart';

@unfreezed
class HBotData with _$HBotData {
  const HBotData._();

  factory HBotData({
    @Default(0) int count,
  }) = _HBotData;

  factory HBotData.fromJson(Map<String, dynamic> json) =>
      _$HBotDataFromJson(json);

  Future<File> save({
    String path = 'hdata.json',
  }) async {
    final file = File(path);
    return file.writeAsString(toJson().toString());
  }

  static Future<HBotData> load({
    String path = 'hdata.json',
  }) async {
    final file = File(path);
    if (!file.existsSync()) {
      return HBotData();
    }

    final json = await file.readAsString();
    return HBotData.fromJson(jsonDecode(json));
  }
}
