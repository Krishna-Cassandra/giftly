import 'package:flutter/material.dart';
import 'package:giftly/screens/home_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // NotificationHelper.initialize();

  runApp(Giftly());
}

class Giftly extends StatelessWidget {
  const Giftly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
