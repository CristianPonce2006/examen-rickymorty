import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/personaje_service.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PersonajesService())],
      child: MaterialApp(
        title: 'Rick and Morty Dex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF24282F),
          scaffoldBackgroundColor: Colors.grey.shade100,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF24282F),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF24282F),
            secondary: const Color(0xFF97CE4C),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
