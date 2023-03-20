import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:prime_numbers/prime_numbers.dart';
import 'package:wheresapp/data/database.dart';

import '../models/public_keys_model.dart';

class KeyGenerator {
  static PublicKeysModel generateAuthorPublicKeys(String chatId) {
    int privateNumber = Random().nextInt(20);

    Database(chatId: chatId).privateNumber = privateNumber;

    final prime = PrimeNumbers().generate(20)[Random().nextInt(20)];

    final generator = Random().nextInt(100);

    final powerOfPrimeNumber = pow(prime, privateNumber);

    final result = (powerOfPrimeNumber % generator).toInt();

    return PublicKeysModel(prime: prime, generator: generator, result: result);
  }

  static PublicKeysModel generateCorrespondentPublicKeys(
      String chatId, PublicKeysModel authorPublicKeys) {
    int privateNumber = Random().nextInt(20);

    Database(chatId: chatId).privateNumber = privateNumber;

    final result = (pow(authorPublicKeys.prime, privateNumber) %
            authorPublicKeys.generator)
        .toInt();

    return PublicKeysModel(
        prime: authorPublicKeys.prime,
        generator: authorPublicKeys.generator,
        result: result);
  }

  static void generateSecret(
      String chatId, PublicKeysModel keys, int privateNumber) {
    String key = (pow(keys.result, privateNumber) % keys.generator).toString();

    final keyBytes = utf8.encode(key);
    final keyHash = sha256.convert(keyBytes).toString();

    Database(chatId: chatId).key = keyHash;
  }
}
