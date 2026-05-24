// =============================================================================
// ARQUIVO: lib/services/compartilhamento_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que usa o COMPARTILHAMENTO NATIVO do celular, através do
//   pacote 'share_plus'. (Funcionalidade extra: Compartilhamento Nativo.)
//
//   RESPONSABILIDADE:
//   - Abrir o menu de compartilhamento do Android (WhatsApp, Instagram,
//     e-mail, Telegram, etc.) com um texto sobre o estabelecimento.
// =============================================================================

import 'package:share_plus/share_plus.dart';

import '../models/estabelecimento_model.dart';

class CompartilhamentoService {
  // -------------------------------------------------------------------------
  // MÉTODO: compartilharEstabelecimento
  // -------------------------------------------------------------------------
  // Monta um texto com as informações do estabelecimento e abre o menu
  // nativo de compartilhamento do celular.
  Future<void> compartilharEstabelecimento(
    EstabelecimentoModel estabelecimento,
  ) async {
    // Monta o texto que será compartilhado.
    // Inclui o nome, a categoria, a descrição e um link do mapa.
    final String texto = '''
Conheça ${estabelecimento.nome}!

Categoria: ${estabelecimento.categoria}
${estabelecimento.descricao}

Veja no mapa:
https://www.google.com/maps/search/?api=1&query=${estabelecimento.latitude},${estabelecimento.longitude}

Compartilhado pelo app Guia do Roteiro do Vinho.
''';

    // 'SharePlus.instance.share' abre o menu nativo de compartilhamento.
    // 'ShareParams' descreve o que será compartilhado (aqui, um texto).
    await SharePlus.instance.share(
      ShareParams(text: texto),
    );
  }
}
