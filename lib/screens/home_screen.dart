// =============================================================================
// ARQUIVO: lib/screens/home_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela principal, exibida DEPOIS que o usuário faz login.
//
//   Funciona como uma "bancada de testes": mostra os dados do usuário logado
//   e tem botões para abrir/testar cada funcionalidade do app.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import 'mapa_screen.dart';
import 'geolocalizacao_screen.dart';
import 'lista_estabelecimentos_screen.dart';
import 'favoritos_screen.dart';
import 'sensor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Esta tela OUVE o AuthController para pegar os dados do usuário.
    final AuthController auth = context.watch<AuthController>();
    final usuario = auth.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------------------------------------------------------
              // FOTO DO USUÁRIO
              // ---------------------------------------------------------------
              if (usuario?.fotoUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(usuario!.fotoUrl!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),

              const SizedBox(height: 20),

              // ---------------------------------------------------------------
              // NOME E E-MAIL DO USUÁRIO
              // ---------------------------------------------------------------
              Text(
                usuario?.nome ?? 'Sem nome',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                usuario?.email ?? 'Sem e-mail',
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // ---------------------------------------------------------------
              // BOTÃO: ABRIR O MAPA (Funcionalidade 2)
              // ---------------------------------------------------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Abrir Mapa'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapaScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // BOTÃO: GEOLOCALIZAÇÃO (Funcionalidade 3)
              // ---------------------------------------------------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Geolocalização'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GeolocalizacaoScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // BOTÃO: ESTABELECIMENTOS (Funcionalidades 4, 5 e extras 1-3)
              // ---------------------------------------------------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Estabelecimentos'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ListaEstabelecimentosScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // BOTÃO: MEUS FAVORITOS (Funcionalidade 5)
              // ---------------------------------------------------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text('Meus Favoritos'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritosScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // BOTÃO: CHACOALHE PARA DESCOBRIR (Funcionalidade extra 6)
              // ---------------------------------------------------------------
              ElevatedButton.icon(
                icon: const Icon(Icons.vibration),
                label: const Text('Chacoalhe para Descobrir'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SensorScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // BOTÃO SAIR (testa o logout)
              // ---------------------------------------------------------------
              if (auth.carregando)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                  onPressed: () {
                    context.read<AuthController>().fazerLogout();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
