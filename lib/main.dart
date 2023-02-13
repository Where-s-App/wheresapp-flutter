import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/views/login.dart';

import 'api/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Wheresapp',
      theme: ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.blue.shade700,
          primaryColorLight: Colors.blue.shade300,
          cardColor: Colors.blue.shade100,
          backgroundColor: Colors.grey.shade50,
          shadowColor: Colors.grey.shade300,
          scaffoldBackgroundColor: Colors.grey.shade400,
          textTheme: const TextTheme(
              headlineSmall: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              bodyMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400))),
      home: Login(),
    );
  }
}
