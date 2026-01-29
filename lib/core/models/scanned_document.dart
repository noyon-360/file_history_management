import 'dart:convert';

class ScannedDocument {
  final String id;
  final String name;
  final String filePath;
  final DateTime dateTime;

  ScannedDocument({
    required this.id,
    required this.name,
    required this.filePath,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory ScannedDocument.fromMap(Map<String, dynamic> map) {
    return ScannedDocument(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      filePath: map['filePath'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannedDocument.fromJson(String source) =>
      ScannedDocument.fromMap(json.decode(source));
}
