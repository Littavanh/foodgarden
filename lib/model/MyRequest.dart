// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyRequest {
  String requestID;
  String requestNo;
  String requestType;
  String otdate;
  String managerName;
  String submitDate;
  String statusText;
  String fileName;

  MyRequest({
    required this.requestID,
    required this.requestNo,
    required this.requestType,
    required this.otdate,
    required this.managerName,
    required this.submitDate,
    required this.statusText,
    required this.fileName,
   
  });

  MyRequest copyWith({
    String? requestID,
    String? requestNo,
    String? requestType,
    String? otdate,
    String? managerName,
    String? submitDate,
    String? statusText,
    String? fileName,
    String? attachedFile,
  }) {
    return MyRequest(
      requestID: requestID ?? this.requestID,
      requestNo: requestNo ?? this.requestNo,
      requestType: requestType ?? this.requestType,
      otdate: otdate ?? this.otdate,
      managerName: managerName ?? this.managerName,
      submitDate: submitDate ?? this.submitDate,
      statusText: statusText ?? this.statusText,
      fileName: fileName ?? this.fileName,
   
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestID': requestID,
      'requestNo': requestNo,
      'requestType': requestType,
      'otdate': otdate,
      'managerName': managerName,
      'submitDate': submitDate,
      'statusText': statusText,
      'fileName': fileName,
     
    };
  }

  factory MyRequest.fromMap(Map<String, dynamic> map) {
    return MyRequest(
      requestID: map['requestID'] as String,
      requestNo: map['requestNo'] as String,
      requestType: map['requestType'] as String,
      otdate: map['otdate'] as String,
      managerName: map['managerName'] as String,
      submitDate: map['submitDate'] as String,
      statusText: map['statusText'] as String,
      fileName: map['fileName'] as String,
    
    );
  }

  String toJson() => json.encode(toMap());

  factory MyRequest.fromJson(String source) =>
      MyRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyRequest(requestID: $requestID, requestNo: $requestNo, requestType: $requestType, otdate: $otdate, managerName: $managerName, submitDate: $submitDate, statusText: $statusText, fileName: $fileName)';
  }

  @override
  bool operator ==(covariant MyRequest other) {
    if (identical(this, other)) return true;

    return other.requestID == requestID &&
        other.requestNo == requestNo &&
        other.requestType == requestType &&
        other.otdate == otdate &&
        other.managerName == managerName &&
        other.submitDate == submitDate &&
        other.statusText == statusText &&
        other.fileName == fileName;
      
  }

  @override
  int get hashCode {
    return requestID.hashCode ^
        requestNo.hashCode ^
        requestType.hashCode ^
        otdate.hashCode ^
        managerName.hashCode ^
        submitDate.hashCode ^
        statusText.hashCode ^
        fileName.hashCode ;
      
  }

  static Future<List<MyRequest>> fecth({
    required String tokenKey,
    required String lang,
  }) async {
    final response = await http.post(
        Uri.parse('http://192.168.100.28:44375/api/User/MyRequest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"tokenKey": tokenKey, "lang": lang}));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      final json = jsonDecode(response.body);
      List<MyRequest> data = List<MyRequest>.from(
            json['ResultObject'].map((x) => MyRequest.fromMap(x)));
      return data;
    } else {
      // print(response.statusCode);
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
