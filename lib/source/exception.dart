// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

class CustomException implements Exception {
  final _error;
  final _prefix;

  @override
  String toString() {
    if (_error.contains('<html>')) {
      return _prefix + "Server is timeout";
    }
    MessageExtention ex = MessageExtention.formatJson(jsonDecode(_error));
    return _prefix + ex.error;
  }

  CustomException(this._error, this._prefix);
}

class MessageExtention {
  final String error;
  MessageExtention(this.error);
  factory MessageExtention.formatJson(dynamic json) {
    if (json is String) {
      return MessageExtention(json);
    } else if (json['message'] != null) {
      return MessageExtention(json['message'] as String);
    } else if (json['error']['message'] != null) {
      return MessageExtention(json['error']['message'] as String);
    } else {
      return MessageExtention(json as String);
    }
  }
}

class FetchDataException extends CustomException {
  FetchDataException({required error})
      : super(error, '' /*'Failure fetching data:\n'*/);
}

class BadRequestException extends CustomException {
  BadRequestException({required error})
      : super(error, '' /*'Invalid request:\n'*/);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException({required error}) : super(error, 'Unauthorized:\n');
}

class InvalidInputException extends CustomException {
  InvalidInputException({required error}) : super(error, 'Invalid Input:\n');
}
