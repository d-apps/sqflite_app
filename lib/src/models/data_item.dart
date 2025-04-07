class DataItem {
  final int? id;
  final String title;
  final String desc;
  final String? createdAt;
  final bool isCompleted;

  DataItem({
    this.id,
    required this.title,
    required this.desc,
    String? createdAt,
    this.isCompleted = false,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'createdAt': createdAt,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory DataItem.fromMap(Map<String, dynamic> map) {
    return DataItem(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      createdAt: map['createdAt'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  DataItem copyWith({
    int? id,
    String? title,
    String? desc,
    String? createdAt,
    bool? isCompleted,
  }) {
    return DataItem(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static Map<String, String> get columnDefinitions => {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'title': 'TEXT NOT NULL',
    'desc': 'TEXT',
    'createdAt': 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
    'isCompleted': 'INTEGER DEFAULT 0',
  };

  static String get createTableSQL {
    final columns = columnDefinitions.entries
        .map((e) => '${e.key} ${e.value}')
        .join(', ');
    return 'CREATE TABLE data($columns)';
  }
}
