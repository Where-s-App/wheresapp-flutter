import 'dart:math';

import 'package:prime_numbers/prime_numbers.dart';

class KeyGenerator {
  late int primeNumber;
  late int generator;
  late int result;

  KeyGenerator() {
    int privateNumber = Random().nextInt(100);

    primeNumber = PrimeNumbers().generate(100)[Random().nextInt(100)];

    generator = Random().nextInt(100);

    final powerOfPrimeNumber = pow(primeNumber, privateNumber);

    result = (powerOfPrimeNumber % generator).toInt();
  }
}
