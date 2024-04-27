class Todo {
  num createdTime;
  String title;
  String id;
  String userId;
  String description;
  bool isDone;

  Todo({
    required this.createdTime,
    required this.title,
    this.description = '',
    required this.id,
    required this.userId,
    this.isDone = false,
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        createdTime: json['createdTime'],
        title: json['title'],
        description: json['description'],
        id: json['id'],
        userId: json['userId'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'createdTime': createdTime,
        'title': title,
        'description': description,
        'id': id,
        'userId': userId,
        'isDone': isDone,
      };
}
