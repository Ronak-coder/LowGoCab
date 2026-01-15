import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lowgo_cab/utils/constants.dart';
import 'package:lowgo_cab/views/home_page.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:lowgo_cab/firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    print('DEBUG: Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('DEBUG: Firebase Initialized successfully.');
  } catch (e) {
    print('DEBUG: Firebase Init Error: $e');
  }
  runApp(const LowGoCabApp());
}

class LowGoCabApp extends StatelessWidget {
  const LowGoCabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const HomePage(),
    );
  }
}
