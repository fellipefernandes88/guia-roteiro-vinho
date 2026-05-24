// =============================================================================
// ARQUIVO: lib/controllers/geolocalizacao_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller da tela de Geolocalização (Funcionalidade 3).
//
//   RESPONSABILIDADE:
//   - Capturar a localização atual do usuário (via LocalizacaoService);
//   - Calcular a distância do usuário até cada estabelecimento;
//   - Ordenar os estabelecimentos do mais perto para o mais longe.
//
//   OBSERVAÇÃO IMPORTANTE:
//   Este controller REUTILIZA o 'LocalizacaoService', o mesmo service usado
//   pelo Mapa. Um único service atende duas funcionalidades diferentes.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/estabelecimento_model.dart';
import '../services/estabelecimentos_data.dart';
import '../services/localizacao_service.dart';

// -----------------------------------------------------------------------------
// CLASSE AUXILIAR: EstabelecimentoComDistancia
// -----------------------------------------------------------------------------
// Junta um estabelecimento com a distância (em metros) até o usuário.
// Precisamos disso porque a distância depende de ONDE o usuário está,
// então ela não pode ficar dentro do EstabelecimentoModel (que é fixo).
class EstabelecimentoComDistancia {
  final EstabelecimentoModel estabelecimento;
  final double distanciaMetros;

  EstabelecimentoComDistancia({
    required this.estabelecimento,
    required this.distanciaMetros,
  });

  // Atalho que devolve a distância já formatada como texto amigável.
  // Ex: 850 metros vira "850 m"; 1500 metros vira "1.5 km".
  String get distanciaFormatada {
    if (distanciaMetros < 1000) {
      // Menos de 1 km: mostra em metros, sem casas decimais.
      return '${distanciaMetros.toStringAsFixed(0)} m';
    } else {
      // 1 km ou mais: converte para km com 1 casa decimal.
      final double km = distanciaMetros / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }
}

class GeolocalizacaoController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTA QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  // -------------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------------

  // A posição atual do usuário. 'null' enquanto não foi capturada.
  Position? _posicaoUsuario;
  Position? get posicaoUsuario => _posicaoUsuario;

  // A lista de estabelecimentos com suas distâncias, já ordenada.
  // Começa vazia; é preenchida depois que a localização é capturada.
  List<EstabelecimentoComDistancia> _estabelecimentosOrdenados = [];
  List<EstabelecimentoComDistancia> get estabelecimentosOrdenados =>
      _estabelecimentosOrdenados;

  // Indica se uma operação está em andamento.
  bool _carregando = false;
  bool get carregando => _carregando;

  // Mensagem de erro, se algo falhar. 'null' = sem erro.
  String? _erro;
  String? get erro => _erro;

  // -------------------------------------------------------------------------
  // MÉTODO: atualizarLocalizacao
  // -------------------------------------------------------------------------
  // Captura a localização do usuário e calcula as distâncias.
  // A tela chama este método (ex: ao tocar no botão "Atualizar localização").
  Future<void> atualizarLocalizacao() async {
    // 1) Liga o "carregando" e limpa erro antigo.
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      // 2) Pede ao service a localização atual.
      _posicaoUsuario = await _localizacaoService.obterLocalizacaoAtual();

      // 3) Com a localização em mãos, calcula a distância até cada local.
      _calcularDistancias();
    } catch (e) {
      // Se algo deu errado (GPS off, permissão negada), guarda a mensagem.
      _erro = e.toString().replaceAll('Exception: ', '');
    }

    // 4) Desliga o "carregando" e avisa a tela.
    _carregando = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _calcularDistancias
  // -------------------------------------------------------------------------
  // Para cada estabelecimento, calcula a distância até o usuário e monta
  // a lista ordenada (do mais perto para o mais longe).
  void _calcularDistancias() {
    // Segurança: sem posição do usuário, não há o que calcular.
    if (_posicaoUsuario == null) return;

    // Cria uma lista temporária para montar o resultado.
    final List<EstabelecimentoComDistancia> resultado = [];

    // Percorre todos os estabelecimentos da fonte de dados.
    for (final EstabelecimentoModel local in EstabelecimentosData.lista) {
      // Pede ao service para calcular a distância em metros.
      final double distancia = _localizacaoService.calcularDistancia(
        _posicaoUsuario!.latitude,
        _posicaoUsuario!.longitude,
        local.latitude,
        local.longitude,
      );

      // Adiciona o estabelecimento + distância na lista temporária.
      resultado.add(
        EstabelecimentoComDistancia(
          estabelecimento: local,
          distanciaMetros: distancia,
        ),
      );
    }

    // Ordena a lista: 'sort' compara dois itens por vez.
    // Comparar a distância de 'a' com a de 'b' coloca o menor primeiro.
    resultado.sort(
      (a, b) => a.distanciaMetros.compareTo(b.distanciaMetros),
    );

    // Guarda o resultado final no estado do controller.
    _estabelecimentosOrdenados = resultado;
  }
}
