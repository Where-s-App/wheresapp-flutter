class UserModel {
  final String name;

  const UserModel({
    required this.name,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
