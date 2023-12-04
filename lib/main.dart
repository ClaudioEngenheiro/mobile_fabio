import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'profile_screen.dart';
import 'splash/splash.dart';
import 'cep_screen.dart'; // Importe a tela de busca de CEP

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscar CEP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const CepScreen(), // Defina a tela de busca de CEP como a tela inicial
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// Comente este trecho do theme, caso queira voltar para
      /// o layout anterior
      theme: ThemeData(
        //colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const Scaffold(body: Splash()),
      routes: {
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
