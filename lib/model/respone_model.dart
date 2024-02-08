import 'dart:convert';

class ResponseModel {
  int code;
  String? message;
  String? error;
  dynamic data;
  ResponseModel({
    required this.code,
    required this.message,
    required this.error,
    this.data,
  });

  factory ResponseModel.fromMap(
      {required Map<String, dynamic> map, required int code, String? name}) {
    return ResponseModel(
        code: code,
        message: map['message'],
        error: map['error'] != null ? map['error']['message'] : null,
        data: map[name]);
  }

  factory ResponseModel.fromJson(
          {required String source, required int code, String? name}) =>
      ResponseModel.fromMap(map: json.decode(source), code: code, name: name);
}
