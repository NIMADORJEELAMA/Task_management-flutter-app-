 

// class Task {
//   final String id;
//   final String title;
//   final String keywordId;
//   final bool isCompleted;
  

//   Task({
//     required this.id,
//     required this.title,
//     required this.keywordId,
//     this.isCompleted = false,
//   });

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['_id'] ?? json['id'], // MongoDB uses _id
//       title: json['title'] ?? '',
//       keywordId: json['keywordId'] ?? '',
//       isCompleted: json['isCompleted'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'keywordId': keywordId,
//       'isCompleted': isCompleted,
//     };
//   }

//   Task copyWith({
//     String? id,
//     String? title,
//     String? keywordId,
//     bool? isCompleted,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       keywordId: keywordId ?? this.keywordId,
//       isCompleted: isCompleted ?? this.isCompleted,
//     );
//   }
// }


class Task {
  final String id;
  final String title;
  final String? keywordId;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.keywordId,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? json['id'], // MongoDB _id
      title: json['title'] ?? '',
      keywordId: json['keywordId'] ?? json['keyword_id'],
      isCompleted: json['completed'] ?? json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (keywordId != null) 'keyword_id': keywordId,
      'completed': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? keywordId,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      keywordId: keywordId ?? this.keywordId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
