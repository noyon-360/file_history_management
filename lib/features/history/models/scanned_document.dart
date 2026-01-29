class ScannedDocument {
  final String id;
  final String name;
  final String filePath;
  final DateTime dateTime;
  final bool isFavorite;
  final int fileSize;
  final DateTime? deletedAt;

  ScannedDocument({
    required this.id,
    required this.name,
    required this.filePath,
    required this.dateTime,
    this.isFavorite = false,
    this.fileSize = 0,
    this.deletedAt,
  });

  String get extension => filePath.split('.').last.toUpperCase();
  bool get isDeleted => deletedAt != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
      'fileSize': fileSize,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory ScannedDocument.fromMap(Map<String, dynamic> map) {
    return ScannedDocument(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      filePath: map['filePath'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] ?? 0),
      isFavorite: map['isFavorite'] ?? false,
      fileSize: map['fileSize'] ?? 0,
      deletedAt: map['deletedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'])
          : null,
    );
  }

  ScannedDocument copyWith({
    String? name,
    bool? isFavorite,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return ScannedDocument(
      id: id,
      name: name ?? this.name,
      filePath: filePath,
      dateTime: dateTime,
      isFavorite: isFavorite ?? this.isFavorite,
      fileSize: fileSize,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
