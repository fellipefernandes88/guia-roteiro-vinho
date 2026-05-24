// =============================================================================
// ARQUIVO: lib/services/sensor_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que usa o ACELERÔMETRO do celular, através do pacote
//   'sensors_plus'. (Funcionalidade extra 6: Sensores do Dispositivo.)
//
//   RESPONSABILIDADE:
//   - Escutar o acelerômetro e detectar quando o usuário CHACOALHA o celular.
//
//   COMO FUNCIONA A DETECÇÃO DE CHACOALHO:
//   O acelerômetro informa a aceleração nos 3 eixos (X, Y, Z). Quando o
//   celular está parado, esses valores são pequenos. Quando é chacoalhado,
//   a aceleração fica alta. Se ela passar de um certo limite, consideramos
//   que houve um "chacoalho".
// =============================================================================

import 'dart:async'; // necessário para StreamSubscription.
import 'dart:math'; // necessário para a raiz quadrada (sqrt).
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  // -------------------------------------------------------------------------
  // CONSTANTE: o limite de força para considerar um "chacoalho".
  // -------------------------------------------------------------------------
  // Quanto maior o número, mais forte precisa ser o movimento.
  // O valor 20 é um bom equilíbrio (chacoalho normal passa disso).
  static const double _limiteChacoalho = 20.0;

  // Guarda a "assinatura" do acelerômetro, para poder parar de escutar depois.
  StreamSubscription? _assinatura;

  // -------------------------------------------------------------------------
  // MÉTODO: iniciarDeteccaoDeChacoalho
  // -------------------------------------------------------------------------
  // Começa a escutar o acelerômetro. Toda vez que detectar um chacoalho,
  // chama a função 'aoChacoalhar' que foi passada como parâmetro.
  void iniciarDeteccaoDeChacoalho(void Function() aoChacoalhar) {
    // 'accelerometerEventStream()' é o fluxo de dados do acelerômetro.
    _assinatura = accelerometerEventStream().listen((evento) {
      // 'evento' tem a aceleração nos 3 eixos: evento.x, evento.y, evento.z.

      // Calcula a "força total" do movimento combinando os 3 eixos.
      // A fórmula é a raiz quadrada de (x² + y² + z²) — é o tamanho do
      // vetor de aceleração, ou seja, a intensidade total do movimento.
      final double forca = sqrt(
        evento.x * evento.x +
            evento.y * evento.y +
            evento.z * evento.z,
      );

      // Se a força passou do limite, foi um chacoalho.
      if (forca > _limiteChacoalho) {
        aoChacoalhar(); // executa a ação combinada.
      }
    });
  }

  // -------------------------------------------------------------------------
  // MÉTODO: pararDeteccao
  // -------------------------------------------------------------------------
  // Para de escutar o acelerômetro. Importante chamar quando a tela fecha,
  // para não desperdiçar bateria.
  void pararDeteccao() {
    _assinatura?.cancel();
    _assinatura = null;
  }
}
