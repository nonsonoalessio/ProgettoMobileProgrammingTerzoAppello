class StringModel {
  String name;

  StringModel({required this.name});

  Map<String, Object?> toMap() {
    return {'name': name};
  }
}
