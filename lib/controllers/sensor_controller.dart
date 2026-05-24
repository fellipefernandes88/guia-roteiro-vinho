// =============================================================================
// ARQUIVO: lib/controllers/sensor_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller da tela "Chacoalhe para descobrir" (Funcionalidade extra 6).
//
//   RESPONSABILIDADE:
//   - Ligar/desligar a detecção de chacoalho (via SensorService);
//   - Quando o celular é chacoalhado, sortear um estabelecimento aleatório
//     do Roteiro do Vinho e guardá-lo para a tela mostrar.
// =============================================================================

import 'dart:math'; // necessário para sortear (Random).
import 'package:flutter/material.dart';

import '../models/estabelecimento_model.dart';
import '../services/estabelecimentos_data.dart';
import '../services/sensor_service.dart';

class SensorController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTAS QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final SensorService _sensorService = SensorService();

  // 'Random' é o gerador de números aleatórios, usado para sortear.
  final Random _sorteador = Random();

  // -------------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------------

  // O estabelecimento sorteado. 'null' enquanto nada foi sorteado.
  EstabelecimentoModel? _estabelecimentoSorteado;
  EstabelecimentoModel? get estabelecimentoSorteado =>
      _estabelecimentoSorteado;

  // Evita sortear várias vezes seguidas se o chacoalho durar um pouco.
  // Funciona como uma "trava" temporária.
  bool _processandoChacoalho = false;

  // -------------------------------------------------------------------------
  // MÉTODO: iniciar
  // -------------------------------------------------------------------------
  // Liga a detecção de chacoalho. A tela chama isto ao abrir.
  void iniciar() {
    _sensorService.iniciarDeteccaoDeChacoalho(_aoChacoalhar);
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _aoChacoalhar
  // -------------------------------------------------------------------------
  // Roda toda vez que o SensorService detecta um chacoalho.
  void _aoChacoalhar() {
    // Se já estamos processando um chacoalho recente, ignora este.
    if (_processandoChacoalho) return;

    // Liga a trava para não sortear em sequência.
    _processandoChacoalho = true;

    // Sorteia um estabelecimento.
    _sortearEstabelecimento();

    // Depois de 1 segundo, libera a trava para um novo chacoalho.
    Future.delayed(const Duration(seconds: 1), () {
      _processandoChacoalho = false;
    });
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _sortearEstabelecimento
  // -------------------------------------------------------------------------
  // Escolhe um estabelecimento aleatório da lista.
  void _sortearEstabelecimento() {
    final lista = EstabelecimentosData.lista;

    // 'nextInt(n)' devolve um número aleatório de 0 até n-1.
    // Usamos o tamanho da lista para sortear uma posição válida.
    final int indiceSorteado = _sorteador.nextInt(lista.length);

    // Guarda o estabelecimento daquela posição.
    _estabelecimentoSorteado = lista[indiceSorteado];

    // Avisa a tela para mostrar o resultado.
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: dispose
  // -------------------------------------------------------------------------
  // Roda quando o controller é destruído. Paramos de escutar o sensor
  // para não desperdiçar bateria.
  @override
  void dispose() {
    _sensorService.pararDeteccao();
    super.dispose();
  }
}
