// =============================================================================
// ARQUIVO: lib/screens/geolocalizacao_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela da Geolocalização (Funcionalidade 3).
//
//   O QUE ELA MOSTRA:
//   - A localização atual do usuário (latitude e longitude);
//   - A lista de estabelecimentos ordenada do mais perto para o mais longe,
//     com a distância de cada um.
//
//   É uma tela de teste, intencionalmente simples. O visual final será
//   refeito por outro integrante do grupo.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/geolocalizacao_controller.dart';

class GeolocalizacaoScreen extends StatelessWidget {
  const GeolocalizacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 'watch' faz a tela OUVIR o controller e se atualizar quando ele mudar.
    final GeolocalizacaoController geo =
        context.watch<GeolocalizacaoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocalização'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Alinha o conteúdo à esquerda.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------------
            // BOTÃO: ATUALIZAR LOCALIZAÇÃO
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity, // ocupa toda a largura.
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Atualizar minha localização'),
                onPressed: () {
                  // Pede ao controller para capturar a localização.
                  context
                      .read<GeolocalizacaoController>()
                      .atualizarLocalizacao();
                },
              ),
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------------------
            // ÁREA QUE MUDA conforme o estado do controller.
            // ---------------------------------------------------------------
            // Caso 1: está carregando -> mostra o círculo girando.
            if (geo.carregando)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )

            // Caso 2: deu erro -> mostra a mensagem de erro.
            else if (geo.erro != null)
              Expanded(
                child: Center(
                  child: Text(
                    geo.erro!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              )

            // Caso 3: ainda não capturou a localização -> instrução inicial.
            else if (geo.posicaoUsuario == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'Toque no botão acima para descobrir sua\n'
                    'localização e os estabelecimentos mais próximos.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )

            // Caso 4: tudo certo -> mostra a localização e a lista.
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Localização atual do usuário ---
                    Text(
                      'Sua localização atual:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Latitude: ${geo.posicaoUsuario!.latitude}',
                    ),
                    Text(
                      'Longitude: ${geo.posicaoUsuario!.longitude}',
                    ),
                    const Divider(height: 24), // linha separadora.

                    Text(
                      'Estabelecimentos mais próximos:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // --- Lista ordenada por distância ---
                    // 'Expanded' + 'ListView' cria uma lista rolável.
                    Expanded(
                      child: ListView.builder(
                        // Quantos itens a lista tem.
                        itemCount: geo.estabelecimentosOrdenados.length,
                        // Como desenhar cada item (chamado um por um).
                        itemBuilder: (context, indice) {
                          // Pega o item desta posição da lista.
                          final item =
                              geo.estabelecimentosOrdenados[indice];

                          // 'ListTile' é uma linha pronta de lista.
                          return ListTile(
                            leading: const Icon(Icons.wine_bar),
                            title: Text(item.estabelecimento.nome),
                            subtitle: Text(item.estabelecimento.categoria),
                            // A distância aparece à direita, em destaque.
                            trailing: Text(
                              item.distanciaFormatada,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
