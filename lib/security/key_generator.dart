import 'dart:math';

import 'package:hive/hive.dart';
import 'package:prime_numbers/prime_numbers.dart';

class KeyGenerator {
  late int primeNumber;
  late int generator;
  late int result;

  KeyGenerator(String chatId) {
    int privateNumber = Random().nextInt(100);

    Hive.box('keys').put(chatId, {'privateNumber': privateNumber});

    primeNumber = PrimeNumbers().generate(100)[Random().nextInt(100)];

    generator = Random().nextInt(100);

    final powerOfPrimeNumber = pow(primeNumber, privateNumber);

    result = (powerOfPrimeNumber % generator).toInt();
  }
}
