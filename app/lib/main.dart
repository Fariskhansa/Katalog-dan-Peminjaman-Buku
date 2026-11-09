
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/halaman_utama.dart';

void main() {
  runApp(const PustakaMiniApp());
}

class PustakaMiniApp extends StatelessWidget {
  const PustakaMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pustaka Mini',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HalamanUtama(),
    );
  }
}
