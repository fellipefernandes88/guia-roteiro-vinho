// =============================================================================
// ARQUIVO: lib/widgets/aviso_helper.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um "helper" (ajudante): uma classe com funções utilitárias prontas.
//
//   Este ajuda a exibir AVISOS RÁPIDOS na tela usando o 'SnackBar' — aquela
//   barrinha que sobe na parte de baixo da tela por alguns segundos.
//
//   POR QUE EXISTE:
//   Para mostrar mensagens curtas de forma padronizada em qualquer tela,
//   como "Sem conexão com a internet" ou "Avaliação salva!".
//   Faz parte da Funcionalidade 6 (Tratamento de Erros).
// =============================================================================

import 'package:flutter/material.dart';

class AvisoHelper {
  // -------------------------------------------------------------------------
  // MÉTODO: mostrarErro
  // -------------------------------------------------------------------------
  // Exibe uma barrinha VERMELHA com uma mensagem de erro.
  // 'static' permite chamar sem criar um objeto: AvisoHelper.mostrarErro(...).
  static void mostrarErro(BuildContext context, String mensagem) {
    // 'ScaffoldMessenger' é quem controla os SnackBars da tela.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: mostrarSucesso
  // -------------------------------------------------------------------------
  // Exibe uma barrinha VERDE com uma mensagem de sucesso.
  static void mostrarSucesso(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: mostrarInfo
  // -------------------------------------------------------------------------
  // Exibe uma barrinha cinza/neutra com uma mensagem informativa.
  static void mostrarInfo(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
