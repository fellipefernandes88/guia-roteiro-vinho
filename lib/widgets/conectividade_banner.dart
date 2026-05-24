// =============================================================================
// ARQUIVO: lib/widgets/conectividade_banner.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um widget que "embrulha" o app inteiro e mostra uma FAIXA VERMELHA
//   no topo sempre que o dispositivo está SEM CONEXÃO.
//
//   COMO FUNCIONA:
//   Este widget recebe a tela atual ('child') e a coloca dentro de uma
//   coluna. Acima dela, mostra a faixa de aviso — mas apenas quando o
//   ConectividadeController indicar que está offline.
//
//   Por "embrulhar" o app todo, a faixa aparece em QUALQUER tela.
//   Esta é a parte visual da Funcionalidade 7 (Monitoramento de Conectividade).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/conectividade_controller.dart';

class ConectividadeBanner extends StatelessWidget {
  // 'child' é o conteúdo que será exibido abaixo da faixa (a tela do app).
  final Widget child;

  const ConectividadeBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 'watch' faz este widget OUVIR o ConectividadeController.
    // Quando a conexão muda, este widget se redesenha.
    final ConectividadeController conectividade =
        context.watch<ConectividadeController>();

    return Column(
      children: [
        // ---------------------------------------------------------------
        // A FAIXA DE AVISO
        // ---------------------------------------------------------------
        // Só aparece quando NÃO está conectado ('!conectado').
        if (!conectividade.conectado)
          Container(
            width: double.infinity, // ocupa toda a largura da tela.
            color: Colors.red,
            // 'SafeArea' evita que a faixa fique embaixo da barra de status
            // do celular (relógio, bateria, etc.).
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  // Centraliza o conteúdo da faixa.
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sem conexão com a internet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // ---------------------------------------------------------------
        // O CONTEÚDO DO APP
        // ---------------------------------------------------------------
        // 'Expanded' faz a tela ocupar todo o espaço restante abaixo da faixa.
        Expanded(child: child),
      ],
    );
  }
}
