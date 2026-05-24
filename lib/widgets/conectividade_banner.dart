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
          Material(
            // 'Material' garante que o texto seja desenhado corretamente
            // (com a fonte padrão), mesmo acima da árvore do MaterialApp.
            color: Colors.red,
            child: SafeArea(
              // 'bottom: false' faz o SafeArea proteger apenas o TOPO
              // (empurra a faixa para baixo da câmera/barra de status).
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    // 'Flexible' permite que o texto se ajuste e não corte.
                    Flexible(
                      child: Text(
                        'Sem conexão com a internet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
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
