// =============================================================================
// ARQUIVO: lib/screens/mapa_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela do Mapa Interativo (Funcionalidade 2) com FILTRO por categoria
//   (Funcionalidade extra 5).
//
//   O QUE ELA MOSTRA:
//   - Uma barra de "chips" no topo para filtrar por categoria;
//   - Um mapa do OpenStreetMap;
//   - Um marcador para cada estabelecimento (respeitando o filtro);
//   - A localização atual do usuário (quando capturada).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../controllers/mapa_controller.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  // Ponto central onde o mapa abre: região da Estrada do Vinho, São Roque/SP.
  static const LatLng _centroSaoRoque = LatLng(-23.5050, -47.1050);

  @override
  Widget build(BuildContext context) {
    // 'watch' faz a tela OUVIR o MapaController e se redesenhar quando mudar.
    final MapaController mapa = context.watch<MapaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa - Roteiro do Vinho'),
      ),
      body: Column(
        children: [
          // ===============================================================
          // BARRA DE FILTRO POR CATEGORIA (chips) - Funcionalidade extra 5
          // ===============================================================
          SizedBox(
            height: 56,
            child: ListView(
              // A lista de chips rola na horizontal.
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              // Para cada categoria, cria um chip.
              children: mapa.categorias.map((categoria) {
                // Verifica se este chip é o que está selecionado.
                final bool selecionado =
                    categoria == mapa.categoriaSelecionada;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  // 'ChoiceChip' é um chip que pode estar marcado ou não.
                  child: ChoiceChip(
                    label: Text(categoria),
                    selected: selecionado,
                    onSelected: (_) {
                      // Ao tocar, avisa o controller da categoria escolhida.
                      context
                          .read<MapaController>()
                          .selecionarCategoria(categoria);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ===============================================================
          // O MAPA
          // ===============================================================
          // 'Expanded' faz o mapa ocupar todo o espaço restante da tela.
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: _centroSaoRoque,
                initialZoom: 13.0,
              ),
              children: [
                // --- CAMADA 1: a imagem do mapa (OpenStreetMap) ---
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'br.com.fatec.guia_roteiro_vinho',
                ),

                // --- CAMADA 2: os marcadores dos estabelecimentos ---
                // 'mapa.estabelecimentos' já vem FILTRADO pela categoria.
                MarkerLayer(
                  markers: mapa.estabelecimentos.map((estabelecimento) {
                    return Marker(
                      point: LatLng(
                        estabelecimento.latitude,
                        estabelecimento.longitude,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    );
                  }).toList(),
                ),

                // --- CAMADA 3: o marcador da localização do usuário ---
                if (mapa.posicaoUsuario != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          mapa.posicaoUsuario!.latitude,
                          mapa.posicaoUsuario!.longitude,
                        ),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // ===============================================================
          // BARRA INFERIOR: mostra mensagem de erro, se houver.
          // ===============================================================
          if (mapa.erro != null)
            Container(
              color: Colors.red.shade100,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: Text(
                mapa.erro!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),

      // -----------------------------------------------------------------------
      // BOTÃO FLUTUANTE: capturar a localização do usuário.
      // -----------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MapaController>().localizarUsuario();
        },
        child: mapa.carregando
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.my_location),
      ),
    );
  }
}
