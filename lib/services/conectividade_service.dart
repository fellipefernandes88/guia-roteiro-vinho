// =============================================================================
// ARQUIVO: lib/services/conectividade_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que monitora a CONEXÃO DE INTERNET do dispositivo, usando o
//   pacote 'connectivity_plus'.
//
//   RESPONSABILIDADE:
//   - Verificar se o dispositivo está conectado neste momento;
//   - Fornecer um "fluxo" (stream) que avisa toda vez que a conexão muda.
// =============================================================================

import 'package:connectivity_plus/connectivity_plus.dart';

class ConectividadeService {
  // A ferramenta principal do pacote connectivity_plus.
  final Connectivity _connectivity = Connectivity();

  // -------------------------------------------------------------------------
  // MÉTODO: estaConectado
  // -------------------------------------------------------------------------
  // Verifica AGORA se o dispositivo tem conexão.
  // Devolve 'true' se estiver conectado, 'false' se estiver offline.
  Future<bool> estaConectado() async {
    // 'checkConnectivity' devolve uma LISTA de tipos de conexão ativos
    // (ex: [wifi], [mobile], ou [none] quando não há conexão).
    final List<ConnectivityResult> resultado =
        await _connectivity.checkConnectivity();

    // É considerado conectado se a lista NÃO contém apenas 'none'.
    return _interpretarResultado(resultado);
  }

  // -------------------------------------------------------------------------
  // PROPRIEDADE: mudancasDeConexao
  // -------------------------------------------------------------------------
  // Um "fluxo" (Stream) que emite um aviso TODA VEZ que a conexão muda
  // (o usuário entra no wi-fi, perde o sinal, etc.).
  //
  // Aqui transformamos a lista de tipos de conexão em um simples
  // 'true' (conectado) ou 'false' (offline), usando '.map(...)'.
  Stream<bool> get mudancasDeConexao {
    return _connectivity.onConnectivityChanged.map(_interpretarResultado);
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _interpretarResultado
  // -------------------------------------------------------------------------
  // Recebe a lista de tipos de conexão e devolve 'true' (conectado)
  // ou 'false' (offline).
  bool _interpretarResultado(List<ConnectivityResult> resultado) {
    // Está offline se a lista estiver vazia OU contiver apenas 'none'.
    if (resultado.isEmpty ||
        resultado.every((tipo) => tipo == ConnectivityResult.none)) {
      return false;
    }
    // Caso contrário, há alguma forma de conexão ativa.
    return true;
  }
}
