// =============================================================================
// ARQUIVO: lib/widgets/mensagem_erro_widget.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um "widget" reutilizável: um pedaço de tela pronto para ser usado em
//   qualquer lugar do app.
//
//   Este aqui mostra uma MENSAGEM DE ERRO de forma padronizada: um ícone,
//   o texto do erro e, opcionalmente, um botão "Tentar novamente".
//
//   POR QUE EXISTE:
//   Em vez de cada tela desenhar o erro de um jeito diferente, todas usam
//   este mesmo componente. Resultado: visual consistente e código sem
//   repetição. Esta é a base da Funcionalidade 6 (Tratamento de Erros).
// =============================================================================

import 'package:flutter/material.dart';

class MensagemErroWidget extends StatelessWidget {
  // -------------------------------------------------------------------------
  // PARÂMETROS
  // -------------------------------------------------------------------------
  // 'mensagem' é o texto do erro a ser exibido (obrigatório).
  final String mensagem;

  // 'aoTentarNovamente' é a ação do botão "Tentar novamente".
  // É opcional: se não for informada, o botão simplesmente não aparece.
  final VoidCallback? aoTentarNovamente;

  const MensagemErroWidget({
    super.key,
    required this.mensagem,
    this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de erro, em vermelho.
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),

            // O texto da mensagem de erro.
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            // Botão "Tentar novamente" — só aparece se uma ação foi informada.
            if (aoTentarNovamente != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                onPressed: aoTentarNovamente,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
