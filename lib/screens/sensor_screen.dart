// =============================================================================
// ARQUIVO: lib/screens/sensor_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela "Chacoalhe para Descobrir" (Funcionalidade extra 6: Sensores).
//
//   COMO FUNCIONA:
//   O usuário chacoalha o celular. O acelerômetro detecta o movimento e o
//   app sorteia um estabelecimento aleatório do Roteiro do Vinho para sugerir.
//
//   DETALHE DE ARQUITETURA:
//   Esta tela cria o seu PRÓPRIO SensorController (com um Provider local).
//   Assim o acelerômetro só fica ligado enquanto esta tela está aberta —
//   quando o usuário sai, o controller é destruído e o sensor é desligado,
//   poupando bateria.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sensor_controller.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 'ChangeNotifierProvider' cria o SensorController só para esta tela.
    // '..iniciar()' já liga a detecção de chacoalho assim que é criado.
    return ChangeNotifierProvider(
      create: (_) => SensorController()..iniciar(),
      child: const _SensorConteudo(),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET INTERNO: o conteúdo visual da tela.
// -----------------------------------------------------------------------------
// Separamos em um widget interno para que ele consiga "ouvir" o
// SensorController criado pelo Provider acima.
class _SensorConteudo extends StatelessWidget {
  const _SensorConteudo();

  @override
  Widget build(BuildContext context) {
    // 'watch' faz a tela OUVIR o SensorController.
    final SensorController sensor = context.watch<SensorController>();

    // Pega o estabelecimento que foi sorteado (pode ser nulo no início).
    final sorteado = sensor.estabelecimentoSorteado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chacoalhe para Descobrir'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------------------------------------------------------------
              // ÍCONE E INSTRUÇÃO
              // ---------------------------------------------------------------
              const Icon(Icons.vibration, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Chacoalhe o celular para descobrir\n'
                'um lugar do Roteiro do Vinho!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              // ---------------------------------------------------------------
              // RESULTADO DO SORTEIO
              // ---------------------------------------------------------------
              // Se nada foi sorteado ainda, mostra um aviso.
              if (sorteado == null)
                const Text(
                  'Aguardando o chacoalho...',
                  style: TextStyle(color: Colors.grey),
                )
              // Se já foi sorteado, mostra o estabelecimento sugerido.
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Que tal visitar:',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sorteado.nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sorteado.categoria,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          sorteado.descricao,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
