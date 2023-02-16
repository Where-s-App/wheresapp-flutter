class PublicKeysModel {
  int prime;
  int generator;
  int result;

  PublicKeysModel(
      {required this.prime, required this.generator, required this.result});

  static PublicKeysModel fromJson(Map<String, dynamic> data) {
    return PublicKeysModel(
        prime: data['prime'],
        generator: data['generator'],
        result: data['result']);
  }
}
