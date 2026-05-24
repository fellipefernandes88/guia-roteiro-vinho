// =============================================================================
// ARQUIVO: lib/screens/detalhes_estabelecimento_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela de DETALHES de um estabelecimento.
//
//   Reúne 3 funcionalidades extras em um só lugar:
//   - Abertura de Rotas  -> botão "Como Chegar";
//   - Compartilhamento   -> botão "Compartilhar";
//   - Ligação / WhatsApp -> botões "Ligar" e "WhatsApp".
//
//   Também tem um botão "Avaliar este local" que leva à tela de avaliação.
//
//   A tela recebe um 'EstabelecimentoModel' da tela anterior e mostra
//   suas informações + os botões de ação.
// =============================================================================

import 'package:flutter/material.dart';

import '../models/estabelecimento_model.dart';
import '../services/acoes_externas_service.dart';
import '../services/compartilhamento_service.dart';
import '../widgets/aviso_helper.dart';
import 'avaliacao_screen.dart';

class DetalhesEstabelecimentoScreen extends StatelessWidget {
  // O estabelecimento exibido, recebido da tela anterior.
  final EstabelecimentoModel estabelecimento;

  const DetalhesEstabelecimentoScreen({
    super.key,
    required this.estabelecimento,
  });

  @override
  Widget build(BuildContext context) {
    // Cria as ferramentas (services) que esta tela vai usar.
    final AcoesExternasService acoes = AcoesExternasService();
    final CompartilhamentoService compartilhamento =
        CompartilhamentoService();

    return Scaffold(
      appBar: AppBar(
        title: Text(estabelecimento.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------------
            // INFORMAÇÕES DO ESTABELECIMENTO
            // ---------------------------------------------------------------
            Text(
              estabelecimento.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              estabelecimento.categoria,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              estabelecimento.descricao,
              style: const TextStyle(fontSize: 15),
            ),
            const Divider(height: 32),

            const Text(
              'Ações:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // BOTÃO: COMO CHEGAR (extra - Abertura de Rotas)
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text('Como Chegar'),
                onPressed: () async {
                  // Pede ao service para abrir o app de mapas.
                  final bool deuCerto = await acoes.abrirRota(
                    estabelecimento.latitude,
                    estabelecimento.longitude,
                  );
                  // Se falhar, avisa o usuário (sem travar o app).
                  // 'context.mounted' confirma que a tela ainda está ativa.
                  if (!deuCerto && context.mounted) {
                    AvisoHelper.mostrarErro(
                      context,
                      'Não foi possível abrir o mapa.',
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // BOTÃO: COMPARTILHAR (extra - Compartilhamento Nativo)
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar'),
                onPressed: () {
                  // Abre o menu nativo de compartilhamento.
                  compartilhamento.compartilharEstabelecimento(
                    estabelecimento,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // BOTÃO: LIGAR (extra - Ligação Direta)
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text('Ligar'),
                onPressed: () async {
                  final bool deuCerto =
                      await acoes.ligarPara(estabelecimento.telefone);
                  if (!deuCerto && context.mounted) {
                    AvisoHelper.mostrarErro(
                      context,
                      'Não foi possível abrir o discador.',
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // BOTÃO: WHATSAPP (extra - WhatsApp)
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text('WhatsApp'),
                onPressed: () async {
                  final bool deuCerto =
                      await acoes.abrirWhatsApp(estabelecimento.telefone);
                  if (!deuCerto && context.mounted) {
                    AvisoHelper.mostrarErro(
                      context,
                      'Não foi possível abrir o WhatsApp.',
                    );
                  }
                },
              ),
            ),

            const Divider(height: 32),

            // ---------------------------------------------------------------
            // BOTÃO: AVALIAR ESTE LOCAL (leva à tela de avaliação)
            // ---------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.star),
                label: const Text('Avaliar este local'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AvaliacaoScreen(
                        estabelecimento: estabelecimento,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
