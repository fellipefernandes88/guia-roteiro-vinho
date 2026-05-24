// =============================================================================
// ARQUIVO: lib/screens/lista_estabelecimentos_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Tela que mostra a LISTA de todos os estabelecimentos do Roteiro do Vinho.
//
//   Cada item da lista tem DUAS ações:
//   - Tocar no nome do estabelecimento  -> abre a tela de DETALHES, de onde
//     é possível ver rota, compartilhar, ligar, WhatsApp e avaliar;
//   - Tocar no ícone de coração         -> favorita/desfavorita (Func. 5).
//
//   Esta tela lê os estabelecimentos da fonte de dados local e usa o
//   FavoritosController para saber quais já são favoritos.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/favoritos_controller.dart';
import '../services/estabelecimentos_data.dart';
import 'detalhes_estabelecimento_screen.dart';

// 'StatefulWidget' porque carregamos os favoritos ao abrir a tela.
class ListaEstabelecimentosScreen extends StatefulWidget {
  const ListaEstabelecimentosScreen({super.key});

  @override
  State<ListaEstabelecimentosScreen> createState() =>
      _ListaEstabelecimentosScreenState();
}

class _ListaEstabelecimentosScreenState
    extends State<ListaEstabelecimentosScreen> {
  // -------------------------------------------------------------------------
  // initState: roda UMA VEZ, ao criar a tela.
  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // Carrega os favoritos do banco para os corações já aparecerem certos.
    context.read<FavoritosController>().carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    // Pega a lista completa de estabelecimentos da fonte de dados local.
    final estabelecimentos = EstabelecimentosData.lista;

    // 'watch' faz a tela OUVIR o FavoritosController: quando um favorito
    // muda, a tela se redesenha e o coração se atualiza.
    final FavoritosController favoritos =
        context.watch<FavoritosController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estabelecimentos'),
      ),
      body: ListView.builder(
        itemCount: estabelecimentos.length,
        itemBuilder: (context, indice) {
          // Pega o estabelecimento desta posição da lista.
          final estabelecimento = estabelecimentos[indice];

          // Pergunta ao controller se este estabelecimento é favorito.
          final bool ehFavorito =
              favoritos.ehFavorito(estabelecimento.id);

          return Card(
            child: ListTile(
              leading: const Icon(Icons.wine_bar),
              title: Text(estabelecimento.nome),
              subtitle: Text(estabelecimento.categoria),

              // -----------------------------------------------------------
              // AÇÃO 1: tocar no item -> abrir a tela de detalhes.
              // -----------------------------------------------------------
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalhesEstabelecimentoScreen(
                      estabelecimento: estabelecimento,
                    ),
                  ),
                );
              },

              // -----------------------------------------------------------
              // AÇÃO 2: tocar no coração -> favoritar/desfavoritar.
              // -----------------------------------------------------------
              trailing: IconButton(
                // O ícone muda conforme o estado: coração cheio (vermelho)
                // se for favorito, coração vazio se não for.
                icon: Icon(
                  ehFavorito ? Icons.favorite : Icons.favorite_border,
                  color: ehFavorito ? Colors.red : null,
                ),
                onPressed: () {
                  // Alterna o favorito (liga se desligado, desliga se ligado).
                  context
                      .read<FavoritosController>()
                      .alternarFavorito(estabelecimento);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
