// =============================================================================
// ARQUIVO: lib/controllers/conectividade_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller que mantém o estado de CONEXÃO do app (online ou offline).
//
//   RESPONSABILIDADE:
//   - Saber, a qualquer momento, se o app está online ou offline;
//   - Ficar "escutando" as mudanças de conexão e avisar as telas.
//
//   A faixa visual de "sem conexão" (ConectividadeBanner) usa este controller.
// =============================================================================

import 'dart:async'; // necessário para o 'StreamSubscription'.
import 'package:flutter/material.dart';

import '../services/conectividade_service.dart';

class ConectividadeController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTA QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final ConectividadeService _conectividadeService = ConectividadeService();

  // -------------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------------

  // Indica se o app está conectado. Começa como 'true' (assume conectado
  // até a primeira verificação dizer o contrário).
  bool _conectado = true;
  bool get conectado => _conectado;

  // -------------------------------------------------------------------------
  // A "ASSINATURA" DO FLUXO DE CONEXÃO
  // -------------------------------------------------------------------------
  // Quando ficamos "escutando" um Stream, recebemos uma 'StreamSubscription'.
  // Guardamos ela para poder parar de escutar depois (no 'dispose').
  StreamSubscription<bool>? _assinatura;

  // -------------------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------------------
  // Assim que o controller é criado, ele começa a monitorar a conexão.
  ConectividadeController() {
    _iniciarMonitoramento();
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _iniciarMonitoramento
  // -------------------------------------------------------------------------
  Future<void> _iniciarMonitoramento() async {
    // 1) Verifica a conexão AGORA (estado inicial).
    _conectado = await _conectividadeService.estaConectado();
    notifyListeners();

    // 2) Passa a ESCUTAR as mudanças de conexão.
    //    Toda vez que a conexão mudar, o bloco abaixo roda.
    _assinatura = _conectividadeService.mudancasDeConexao.listen(
      (estaConectado) {
        // Atualiza o estado e avisa as telas (a faixa aparece/some).
        _conectado = estaConectado;
        notifyListeners();
      },
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: dispose
  // -------------------------------------------------------------------------
  // Roda quando o controller é destruído. Paramos de escutar o fluxo
  // para não desperdiçar recursos do celular.
  @override
  void dispose() {
    _assinatura?.cancel(); // cancela a assinatura, se existir.
    super.dispose();
  }
}
