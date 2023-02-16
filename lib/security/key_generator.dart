import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:prime_numbers/prime_numbers.dart';

import '../models/public_keys_model.dart';

class KeyGenerator {
  static PublicKeysModel generateAuthorPublicKeys(String chatId) {
    int privateNumber = Random().nextInt(20);

    Hive.box('keys').put('$chatId-privateNumber', privateNumber);

    final prime = PrimeNumbers().generate(20)[Random().nextInt(20)];

    final generator = Random().nextInt(100);

    final powerOfPrimeNumber = pow(prime, privateNumber);

    final result = (powerOfPrimeNumber % generator).toInt();

    return PublicKeysModel(prime: prime, generator: generator, result: result);
  }

  static PublicKeysModel generateCorrespondentPublicKeys(
      String chatId, PublicKeysModel authorPublicKeys) {
    int privateNumber = Random().nextInt(20);

    Hive.box('keys').put('$chatId-privateNumber', privateNumber);

    final result = (pow(authorPublicKeys.prime, privateNumber) %
            authorPublicKeys.generator)
        .toInt();

    return PublicKeysModel(
        prime: authorPublicKeys.prime,
        generator: authorPublicKeys.generator,
        result: result);
  }

  static void generateSecret(String chatId, PublicKeysModel keys) {
    final privateNumber = Hive.box('keys').get('$chatId-privateNumber');

    String secret =
        (pow(keys.result, privateNumber) % keys.generator).toString();

    final secretBytes = utf8.encode(secret);
    final secretHash = sha256.convert(secretBytes).toString();

    Hive.box('keys').put('$chatId-secret', secretHash);
  }
}
