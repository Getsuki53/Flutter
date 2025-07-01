import 'package:flutter/material.dart';
import 'package:Flutter/src/view/main_scaffold.dart';
import 'package:Flutter/src/view/sessions/login.dart';
import 'package:Flutter/src/view/sessions/registro.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScaffold(), //home: LoginView(),
    );
  }
}
