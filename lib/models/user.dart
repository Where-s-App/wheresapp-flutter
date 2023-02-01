class User {
  final String name;

  const User({
    required this.name,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
