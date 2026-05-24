// =============================================================================
// ARQUIVO: lib/widgets/carregando_widget.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um widget reutilizável que mostra um indicador de CARREGAMENTO
//   (o círculo girando) com uma mensagem opcional abaixo.
//
//   POR QUE EXISTE:
//   Padroniza a aparência de "carregando" em todas as telas do app,
//   evitando repetição de código.
// =============================================================================

import 'package:flutter/material.dart';

class CarregandoWidget extends StatelessWidget {
  // 'mensagem' é um texto opcional mostrado abaixo do círculo
  // (ex: "Buscando localização..."). Tem um valor padrão.
  final String mensagem;

  const CarregandoWidget({
    super.key,
    this.mensagem = 'Carregando...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // O círculo de carregamento.
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          // A mensagem abaixo.
          Text(mensagem),
        ],
      ),
    );
  }
}
