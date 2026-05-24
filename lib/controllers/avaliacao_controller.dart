// =============================================================================
// ARQUIVO: lib/controllers/avaliacao_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller da tela de Avaliação (Funcionalidade 4) com o Check-in
//   Georreferenciado (Funcionalidade extra 4).
//
//   RESPONSABILIDADE:
//   - Guardar a nota, o comentário e a foto que o usuário está montando;
//   - Pedir ao CameraService para tirar a foto;
//   - Pedir ao DatabaseService para salvar a avaliação no banco;
//   - Carregar as avaliações já feitas de um estabelecimento;
//   - FAZER O CHECK-IN: verificar se o usuário está a no máximo 100 metros
//     do estabelecimento. Só assim a avaliação é liberada.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/avaliacao_model.dart';
import '../services/database_service.dart';
import '../services/camera_service.dart';
import '../services/localizacao_service.dart';

class AvaliacaoController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // CONSTANTE: distância máxima permitida para o check-in.
  // -------------------------------------------------------------------------
  // O PDF do trabalho define 100 metros como o limite.
  static const double distanciaMaximaMetros = 100;

  // -------------------------------------------------------------------------
  // FERRAMENTAS QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final DatabaseService _databaseService = DatabaseService();
  final CameraService _cameraService = CameraService();
  // Reaproveita o mesmo service de localização usado pelo Mapa e Geolocalização.
  final LocalizacaoService _localizacaoService = LocalizacaoService();

  // -------------------------------------------------------------------------
  // ESTADO DO FORMULÁRIO
  // -------------------------------------------------------------------------

  // A nota escolhida pelo usuário (de 1 a 5). Começa em 0 (nada escolhido).
  int _nota = 0;
  int get nota => _nota;

  // O caminho da foto tirada. 'null' enquanto não há foto.
  String? _fotoCaminho;
  String? get fotoCaminho => _fotoCaminho;

  // Indica se uma operação está em andamento (salvando, carregando).
  bool _carregando = false;
  bool get carregando => _carregando;

  // Mensagem de erro, se algo falhar. 'null' = sem erro.
  String? _erro;
  String? get erro => _erro;

  // Indica que a avaliação foi salva com sucesso.
  bool _salvoComSucesso = false;
  bool get salvoComSucesso => _salvoComSucesso;

  // A lista de avaliações já existentes do estabelecimento.
  List<AvaliacaoModel> _avaliacoes = [];
  List<AvaliacaoModel> get avaliacoes => _avaliacoes;

  // -------------------------------------------------------------------------
  // ESTADO DO CHECK-IN
  // -------------------------------------------------------------------------

  // Indica se o check-in foi feito e liberou a avaliação.
  // Começa 'false': a avaliação fica bloqueada até o check-in dar certo.
  bool _checkinLiberado = false;
  bool get checkinLiberado => _checkinLiberado;

  // A distância (em metros) entre o usuário e o estabelecimento.
  // 'null' enquanto o check-in não foi feito.
  double? _distanciaAtual;
  double? get distanciaAtual => _distanciaAtual;

  // Indica se o check-in está sendo verificado no momento.
  bool _verificandoCheckin = false;
  bool get verificandoCheckin => _verificandoCheckin;

  // Mensagem específica do check-in (resultado ou erro).
  String? _mensagemCheckin;
  String? get mensagemCheckin => _mensagemCheckin;

  // -------------------------------------------------------------------------
  // MÉTODO: fazerCheckin
  // -------------------------------------------------------------------------
  // Verifica se o usuário está perto o suficiente do estabelecimento.
  // Recebe as coordenadas do estabelecimento que está sendo avaliado.
  Future<void> fazerCheckin(
    double latEstabelecimento,
    double lonEstabelecimento,
  ) async {
    // Liga o "verificando" e limpa estados antigos do check-in.
    _verificandoCheckin = true;
    _mensagemCheckin = null;
    _checkinLiberado = false;
    notifyListeners();

    try {
      // 1) Pega a localização atual do usuário.
      final Position posicao =
          await _localizacaoService.obterLocalizacaoAtual();

      // 2) Calcula a distância até o estabelecimento.
      _distanciaAtual = _localizacaoService.calcularDistancia(
        posicao.latitude,
        posicao.longitude,
        latEstabelecimento,
        lonEstabelecimento,
      );

      // 3) Decide: o usuário está dentro do limite de 100 metros?
      if (_distanciaAtual! <= distanciaMaximaMetros) {
        // Está perto -> libera a avaliação.
        _checkinLiberado = true;
        _mensagemCheckin =
            'Check-in confirmado! Você está a '
            '${_distanciaAtual!.toStringAsFixed(0)} m do local.';
      } else {
        // Está longe -> mantém bloqueado.
        _checkinLiberado = false;
        _mensagemCheckin =
            'Você está a ${_distanciaAtual!.toStringAsFixed(0)} m do local. '
            'É preciso estar a no máximo '
            '${distanciaMaximaMetros.toStringAsFixed(0)} m para avaliar.';
      }
    } catch (e) {
      // GPS desligado, permissão negada, etc.
      _checkinLiberado = false;
      _mensagemCheckin = e.toString().replaceAll('Exception: ', '');
    }

    _verificandoCheckin = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: definirNota
  // -------------------------------------------------------------------------
  // Chamado quando o usuário toca nas estrelas para escolher a nota.
  void definirNota(int novaNota) {
    _nota = novaNota;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: tirarFoto
  // -------------------------------------------------------------------------
  // Pede ao CameraService para abrir a câmera e guarda o caminho da foto.
  Future<void> tirarFoto() async {
    _erro = null;
    try {
      final String? caminho = await _cameraService.tirarFoto();
      if (caminho != null) {
        _fotoCaminho = caminho;
        notifyListeners();
      }
    } catch (e) {
      _erro = 'Não foi possível usar a câmera.';
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // MÉTODO: salvarAvaliacao
  // -------------------------------------------------------------------------
  // Monta o objeto AvaliacaoModel e pede ao banco para salvar.
  Future<void> salvarAvaliacao({
    required String estabelecimentoId,
    required String estabelecimentoNome,
    required String comentario,
  }) async {
    // VALIDAÇÃO 1: o check-in precisa estar liberado.
    if (!_checkinLiberado) {
      _erro = 'Faça o check-in no local antes de avaliar.';
      notifyListeners();
      return;
    }

    // VALIDAÇÃO 2: a nota é obrigatória.
    if (_nota == 0) {
      _erro = 'Escolha uma nota de 1 a 5.';
      notifyListeners();
      return;
    }

    // Liga o "carregando" e limpa estados antigos.
    _carregando = true;
    _erro = null;
    _salvoComSucesso = false;
    notifyListeners();

    try {
      // Monta o objeto da avaliação com os dados atuais.
      final AvaliacaoModel novaAvaliacao = AvaliacaoModel(
        estabelecimentoId: estabelecimentoId,
        estabelecimentoNome: estabelecimentoNome,
        nota: _nota,
        comentario: comentario,
        fotoCaminho: _fotoCaminho,
        data: DateTime.now().toIso8601String(),
      );

      // Pede ao banco para salvar.
      await _databaseService.salvarAvaliacao(novaAvaliacao);

      // Deu certo: marca sucesso e limpa o formulário.
      _salvoComSucesso = true;
      _nota = 0;
      _fotoCaminho = null;

      // Recarrega a lista de avaliações para mostrar a nova.
      _avaliacoes = await _databaseService
          .listarAvaliacoesPorEstabelecimento(estabelecimentoId);
    } catch (e) {
      _erro = 'Falha ao salvar a avaliação.';
    }

    _carregando = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: carregarAvaliacoes
  // -------------------------------------------------------------------------
  // Busca no banco as avaliações já feitas de um estabelecimento.
  Future<void> carregarAvaliacoes(String estabelecimentoId) async {
    _carregando = true;
    notifyListeners();

    try {
      _avaliacoes = await _databaseService
          .listarAvaliacoesPorEstabelecimento(estabelecimentoId);
    } catch (e) {
      _erro = 'Falha ao carregar as avaliações.';
    }

    _carregando = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: limparFormulario
  // -------------------------------------------------------------------------
  // Zera o estado do formulário e do check-in. Chamado ao abrir a tela,
  // para não aparecerem dados de uma avaliação anterior.
  void limparFormulario() {
    _nota = 0;
    _fotoCaminho = null;
    _erro = null;
    _salvoComSucesso = false;
    _checkinLiberado = false;
    _distanciaAtual = null;
    _mensagemCheckin = null;
    // NÃO chamamos notifyListeners aqui de propósito: este método é chamado
    // durante a construção da tela, e avisar nesse momento causaria erro.
  }
}
