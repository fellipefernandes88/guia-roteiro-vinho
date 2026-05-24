// =============================================================================
// ARQUIVO: lib/screens/favoritos_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela que mostra a lista de estabelecimentos FAVORITADOS pelo usuário
//   (Funcionalidade 5).
//
//   Como os favoritos vêm do banco SQLite local, esta tela funciona
//   mesmo sem internet.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/favoritos_controller.dart';

// 'StatefulWidget' porque precisamos carregar os favoritos ao abrir a tela.
class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  // -------------------------------------------------------------------------
  // initState: roda UMA VEZ, ao criar a tela.
  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // Ao abrir a tela, pede ao controller para carregar os favoritos do banco.
    context.read<FavoritosController>().carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    // 'watch' faz a tela OUVIR o controller e se atualizar quando ele mudar.
    final FavoritosController favoritos =
        context.watch<FavoritosController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Builder(
        builder: (context) {
          // Caso 1: está carregando -> mostra o círculo girando.
          if (favoritos.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          // Caso 2: não há favoritos -> mostra um aviso.
          if (favoritos.favoritos.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não tem estabelecimentos favoritos.\n'
                'Toque no coração na lista de estabelecimentos.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // Caso 3: há favoritos -> mostra a lista.
          return ListView.builder(
            itemCount: favoritos.favoritos.length,
            itemBuilder: (context, indice) {
              final estabelecimento = favoritos.favoritos[indice];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.wine_bar),
                  title: Text(estabelecimento.nome),
                  subtitle: Text(estabelecimento.categoria),
                  // Coração cheio (é favorito). Tocar nele remove o favorito.
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      // Alterna o favorito (aqui, remove).
                      context
                          .read<FavoritosController>()
                          .alternarFavorito(estabelecimento);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
