class Category {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Category(this.id, this.name, this.createdAt, this.updatedAt);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        createdAt = json['createdAt'] as DateTime,
        updatedAt = json['updatedAt'] as DateTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
