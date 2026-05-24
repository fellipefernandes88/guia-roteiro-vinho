// =============================================================================
// ARQUIVO: lib/main.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   O ponto de PARTIDA do aplicativo. Tudo começa aqui, na função 'main()'.
//
//   Responsabilidades deste arquivo:
//   1. Inicializar o Firebase (ligar a conexão com o projeto na nuvem);
//   2. Disponibilizar os controllers para o app inteiro (via Provider);
//   3. Aplicar a faixa global de "sem conexão" sobre todas as telas;
//   4. Decidir qual tela mostrar primeiro: Login ou Home.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Arquivo gerado automaticamente pelo FlutterFire com as chaves do Firebase.
import 'firebase_options.dart';

import 'controllers/auth_controller.dart';
import 'controllers/mapa_controller.dart';
import 'controllers/geolocalizacao_controller.dart';
import 'controllers/avaliacao_controller.dart';
import 'controllers/favoritos_controller.dart';
import 'controllers/conectividade_controller.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/conectividade_banner.dart';

// -----------------------------------------------------------------------------
// FUNÇÃO main: a primeira coisa que roda quando o app abre.
// -----------------------------------------------------------------------------
Future<void> main() async {
  // Garante que o Flutter está pronto antes de rodar código de inicialização.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase usando as chaves do arquivo 'firebase_options.dart'.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicia o aplicativo, exibindo o widget 'MeuApp'.
  runApp(const MeuApp());
}

// -----------------------------------------------------------------------------
// WIDGET MeuApp: a "raiz" do aplicativo.
// -----------------------------------------------------------------------------
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 'MultiProvider' coloca VÁRIOS controllers "no ar" de uma vez,
    // disponíveis para qualquer tela do app.
    return MultiProvider(
      providers: [
        // Controller da autenticação.
        ChangeNotifierProvider(create: (_) => AuthController()),
        // Controller do mapa.
        ChangeNotifierProvider(create: (_) => MapaController()),
        // Controller da geolocalização.
        ChangeNotifierProvider(create: (_) => GeolocalizacaoController()),
        // Controller das avaliações.
        ChangeNotifierProvider(create: (_) => AvaliacaoController()),
        // Controller dos favoritos.
        ChangeNotifierProvider(create: (_) => FavoritosController()),
        // Controller da conectividade (monitora online/offline).
        ChangeNotifierProvider(create: (_) => ConectividadeController()),
      ],
      child: MaterialApp(
        title: 'Guia Roteiro do Vinho',
        debugShowCheckedModeBanner: false, // esconde a faixa "DEBUG".
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),

        // 'builder' permite "embrulhar" TODAS as telas do app com algo.
        // Aqui usamos o ConectividadeBanner: assim a faixa de "sem conexão"
        // aparece sobre qualquer tela, automaticamente.
        builder: (context, child) {
          return ConectividadeBanner(
            // 'child' é a tela atual do app. O '!' garante que não é nulo.
            child: child!,
          );
        },

        // A tela inicial é decidida pelo widget 'TelaInicial' abaixo.
        home: const TelaInicial(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET TelaInicial: decide entre Login e Home.
// -----------------------------------------------------------------------------
// Este widget OUVE o AuthController. Se houver usuário logado, mostra a Home.
// Se não houver, mostra o Login. E faz isso AUTOMATICAMENTE: assim que o
// login ou logout acontece, a tela troca sozinha.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    // 'watch' faz este widget se redesenhar sempre que o estado de login mudar.
    final AuthController auth = context.watch<AuthController>();

    // Se existe alguém logado -> Home. Senão -> Login.
    if (auth.estaLogado) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
