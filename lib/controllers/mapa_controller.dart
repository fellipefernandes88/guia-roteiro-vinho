// =============================================================================
// ARQUIVO: lib/controllers/mapa_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller que comanda a tela do Mapa.
//
//   RESPONSABILIDADE:
//   - Fornecer a lista de estabelecimentos para mostrar no mapa;
//   - Buscar a localização atual do usuário (usando o LocalizacaoService);
//   - FILTRAR os estabelecimentos por categoria (Funcionalidade extra 5);
//   - Guardar o estado: carregando, erro, posição do usuário, filtro.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/estabelecimento_model.dart';
import '../services/estabelecimentos_data.dart';
import '../services/localizacao_service.dart';

class MapaController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTA QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  // -------------------------------------------------------------------------
  // CONSTANTE: o texto usado para representar "todas as categorias".
  // -------------------------------------------------------------------------
  static const String categoriaTodos = 'Todos';

  // -------------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------------

  // A posição atual do usuário. Fica 'null' enquanto não foi capturada.
  Position? _posicaoUsuario;
  Position? get posicaoUsuario => _posicaoUsuario;

  // Indica se a localização está sendo buscada.
  bool _carregando = false;
  bool get carregando => _carregando;

  // Mensagem de erro, se a captura da localização falhar.
  String? _erro;
  String? get erro => _erro;

  // A categoria selecionada no filtro. Começa em "Todos" (mostra tudo).
  String _categoriaSelecionada = categoriaTodos;
  String get categoriaSelecionada => _categoriaSelecionada;

  // -------------------------------------------------------------------------
  // PROPRIEDADE: categorias
  // -------------------------------------------------------------------------
  // Devolve a lista de categorias disponíveis para o filtro, sempre
  // começando com "Todos".
  List<String> get categorias {
    // 'Set' é uma coleção que NÃO repete valores. Usamos para pegar
    // cada categoria uma única vez, mesmo que vários locais a compartilhem.
    final Set<String> categoriasUnicas = EstabelecimentosData.lista
        .map((local) => local.categoria)
        .toSet();

    // Devolve "Todos" seguido das categorias encontradas, em ordem.
    final List<String> resultado = categoriasUnicas.toList()..sort();
    return [categoriaTodos, ...resultado];
  }

  // -------------------------------------------------------------------------
  // PROPRIEDADE: estabelecimentos
  // -------------------------------------------------------------------------
  // Devolve a lista de estabelecimentos JÁ FILTRADA pela categoria escolhida.
  // É esta lista que a tela do mapa usa para desenhar os marcadores.
  List<EstabelecimentoModel> get estabelecimentos {
    // Se o filtro é "Todos", devolve a lista completa.
    if (_categoriaSelecionada == categoriaTodos) {
      return EstabelecimentosData.lista;
    }

    // Senão, devolve só os estabelecimentos da categoria selecionada.
    // '.where(...)' mantém apenas os itens que passam na condição.
    return EstabelecimentosData.lista
        .where((local) => local.categoria == _categoriaSelecionada)
        .toList();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: selecionarCategoria
  // -------------------------------------------------------------------------
  // Chamado quando o usuário toca em um chip de categoria.
  void selecionarCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    notifyListeners(); // avisa a tela: redesenhe os marcadores filtrados.
  }

  // -------------------------------------------------------------------------
  // MÉTODO: localizarUsuario
  // -------------------------------------------------------------------------
  // Pede ao service para capturar a localização atual do usuário.
  Future<void> localizarUsuario() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _posicaoUsuario = await _localizacaoService.obterLocalizacaoAtual();
    } catch (e) {
      _erro = e.toString().replaceAll('Exception: ', '');
    }

    _carregando = false;
    notifyListeners();
  }
}
