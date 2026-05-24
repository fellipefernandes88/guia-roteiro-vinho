// =============================================================================
// ARQUIVO: lib/services/localizacao_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que conversa com o GPS do dispositivo, usando o pacote 'geolocator'.
//
//   RESPONSABILIDADE:
//   - Verificar se o GPS está ligado;
//   - Pedir permissão de localização ao usuário;
//   - Capturar a localização atual (latitude e longitude).
//
//   Este service será usado tanto pelo Mapa (Funcionalidade 2) quanto pela
//   Geolocalização (Funcionalidade 3), por isso ele fica separado e reutilizável.
// =============================================================================

import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  // -------------------------------------------------------------------------
  // MÉTODO: obterLocalizacaoAtual
  // -------------------------------------------------------------------------
  // Devolve a posição atual do usuário ('Position', que tem latitude e
  // longitude). Antes de capturar, faz todas as verificações necessárias.
  //
  // Se algo impedir (GPS desligado, permissão negada), este método LANÇA um
  // erro com uma mensagem clara. Quem chamar deve tratar esse erro.
  Future<Position> obterLocalizacaoAtual() async {
    // -----------------------------------------------------------------------
    // VERIFICAÇÃO 1: o serviço de localização (GPS) está ligado?
    // -----------------------------------------------------------------------
    final bool gpsLigado = await Geolocator.isLocationServiceEnabled();
    if (!gpsLigado) {
      // 'throw' lança um erro, interrompendo o método.
      throw Exception('O GPS está desligado. Ative a localização.');
    }

    // -----------------------------------------------------------------------
    // VERIFICAÇÃO 2: o app tem permissão para usar a localização?
    // -----------------------------------------------------------------------
    // Primeiro consultamos a permissão atual.
    LocationPermission permissao = await Geolocator.checkPermission();

    // Se a permissão ainda não foi decidida, pedimos ao usuário.
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      // Se o usuário negou mesmo depois de pedirmos:
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    // Se o usuário negou permanentemente (marcou "não perguntar de novo"):
    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização negada permanentemente. '
        'Habilite nas configurações do aparelho.',
      );
    }

    // -----------------------------------------------------------------------
    // CAPTURA: tudo certo, agora pegamos a localização.
    // -----------------------------------------------------------------------
    return await Geolocator.getCurrentPosition();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: calcularDistancia
  // -------------------------------------------------------------------------
  // Calcula a distância (em METROS) entre dois pontos do mapa.
  // Será usado para mostrar "quão longe" o usuário está de cada estabelecimento.
  //
  // 'Geolocator.distanceBetween' já faz o cálculo geográfico correto para nós.
  double calcularDistancia(
    double latInicial,
    double lonInicial,
    double latFinal,
    double lonFinal,
  ) {
    return Geolocator.distanceBetween(
      latInicial,
      lonInicial,
      latFinal,
      lonFinal,
    );
  }
}
