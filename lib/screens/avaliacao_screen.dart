// =============================================================================
// ARQUIVO: lib/screens/avaliacao_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A tela onde o usuário AVALIA um estabelecimento (Funcionalidade 4),
//   com o CHECK-IN GEORREFERENCIADO (Funcionalidade extra 4).
//
//   O QUE ELA TEM:
//   - Uma área de CHECK-IN no topo: o usuário precisa confirmar que está
//     a no máximo 100 m do local. Só assim o formulário é liberado;
//   - Estrelas para dar a nota (1 a 5);
//   - Um campo de texto para o comentário;
//   - Um botão para tirar foto com a câmera;
//   - Um botão para salvar a avaliação;
//   - A lista das avaliações já feitas para este estabelecimento.
// =============================================================================

import 'dart:io'; // necessário para exibir a foto a partir do arquivo.
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../controllers/avaliacao_controller.dart';
import '../models/estabelecimento_model.dart';

class AvaliacaoScreen extends StatefulWidget {
  // O estabelecimento que será avaliado, recebido da tela anterior.
  final EstabelecimentoModel estabelecimento;

  const AvaliacaoScreen({super.key, required this.estabelecimento});

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  // 'controladorComentario' gerencia o texto digitado no campo de comentário.
  final TextEditingController _controladorComentario =
      TextEditingController();

  // -------------------------------------------------------------------------
  // initState: roda UMA VEZ, quando a tela é criada.
  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    // Ao abrir a tela, limpamos o formulário e carregamos as avaliações
    // já existentes deste estabelecimento.
    final controller = context.read<AvaliacaoController>();
    controller.limparFormulario();
    controller.carregarAvaliacoes(widget.estabelecimento.id);
  }

  // -------------------------------------------------------------------------
  // dispose: roda quando a tela é fechada. Libera o controlador de texto.
  // -------------------------------------------------------------------------
  @override
  void dispose() {
    _controladorComentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 'watch' faz a tela OUVIR o controller e se atualizar quando ele mudar.
    final AvaliacaoController controller =
        context.watch<AvaliacaoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliar: ${widget.estabelecimento.nome}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================================================
            // ÁREA DE CHECK-IN GEORREFERENCIADO
            // ===============================================================
            // O usuário precisa confirmar que está perto do local.
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Check-in no local',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Para avaliar, você precisa estar a no máximo '
                      '100 metros do estabelecimento.',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),

                    // Botão que dispara a verificação de check-in.
                    if (controller.verificandoCheckin)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton.icon(
                        icon: const Icon(Icons.location_searching),
                        label: const Text('Fazer check-in'),
                        onPressed: () {
                          // Pede ao controller para verificar a distância.
                          context.read<AvaliacaoController>().fazerCheckin(
                                widget.estabelecimento.latitude,
                                widget.estabelecimento.longitude,
                              );
                        },
                      ),

                    // Mensagem do resultado do check-in (verde se liberou,
                    // vermelha se não).
                    if (controller.mensagemCheckin != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        controller.mensagemCheckin!,
                        style: TextStyle(
                          color: controller.checkinLiberado
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===============================================================
            // FORMULÁRIO DE AVALIAÇÃO
            // ===============================================================
            // Só fica VISÍVEL e utilizável se o check-in foi liberado.
            if (!controller.checkinLiberado)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Faça o check-in acima para liberar a avaliação.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- NOTA (estrelas de 1 a 5) ---
                  const Text(
                    'Sua nota:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: controller.nota.toDouble(),
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (novaNota) {
                      context
                          .read<AvaliacaoController>()
                          .definirNota(novaNota.toInt());
                    },
                  ),

                  const SizedBox(height: 20),

                  // --- COMENTÁRIO ---
                  const Text(
                    'Comentário:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controladorComentario,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Escreva sua opinião sobre o local...',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- FOTO ---
                  const Text(
                    'Foto (opcional):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tirar foto'),
                    onPressed: () {
                      context.read<AvaliacaoController>().tirarFoto();
                    },
                  ),

                  // Pré-visualização da foto, se houver.
                  if (controller.fotoCaminho != null) ...[
                    const SizedBox(height: 12),
                    Image.file(
                      File(controller.fotoCaminho!),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // --- BOTÃO SALVAR ---
                  SizedBox(
                    width: double.infinity,
                    child: controller.carregando
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text('Salvar avaliação'),
                            onPressed: () {
                              context
                                  .read<AvaliacaoController>()
                                  .salvarAvaliacao(
                                    estabelecimentoId:
                                        widget.estabelecimento.id,
                                    estabelecimentoNome:
                                        widget.estabelecimento.nome,
                                    comentario:
                                        _controladorComentario.text,
                                  );
                            },
                          ),
                  ),

                  // --- MENSAGENS DE ERRO OU SUCESSO ---
                  if (controller.erro != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      controller.erro!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  if (controller.salvoComSucesso) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Avaliação salva com sucesso!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ],
              ),

            const Divider(height: 32),

            // ===============================================================
            // LISTA DE AVALIAÇÕES JÁ FEITAS
            // ===============================================================
            const Text(
              'Avaliações deste local:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (controller.avaliacoes.isEmpty)
              const Text('Nenhuma avaliação ainda.')
            else
              ...controller.avaliacoes.map((avaliacao) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text('Nota: ${avaliacao.nota} / 5'),
                    subtitle: Text(avaliacao.comentario),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
