import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/favorites_provider.dart';
import 'providers/watched_provider.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (FirebaseAuth.instance.currentUser == null) {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (_) {
      // Sign-in anónimo fallará si no está habilitado en Firebase Console.
      // La app carga de todos modos; los datos en nube no estarán disponibles.
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => WatchedProvider()),
      ],
      child: const CineHubApp(),
    ),
  );
}

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF131313),
        cardColor: const Color(0xFF1C1C1E),
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
