// =============================================================================
// ARQUIVO: lib/services/acoes_externas_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que abre APLICATIVOS EXTERNOS a partir do nosso app, usando o
//   pacote 'url_launcher'.
//
//   RESPONSABILIDADE (as funcionalidades extras 1 e 3):
//   - Abrir o Google Maps/Waze para traçar uma rota até o estabelecimento;
//   - Abrir o discador de telefone;
//   - Abrir uma conversa no WhatsApp.
//
//   COMO FUNCIONA:
//   Cada app externo é aberto por meio de um "link especial" (uma URI).
//   Ex: 'tel:11999998888' abre o discador; 'https://wa.me/...' abre o WhatsApp.
// =============================================================================

import 'package:url_launcher/url_launcher.dart';

class AcoesExternasService {
  // -------------------------------------------------------------------------
  // MÉTODO: abrirRota
  // -------------------------------------------------------------------------
  // Abre o app de mapas do celular traçando uma rota até as coordenadas
  // do estabelecimento. (Funcionalidade extra: Abertura de Rotas.)
  //
  // Usamos um link do Google Maps. O próprio Android pergunta ao usuário
  // com qual app abrir (Google Maps, Waze, etc.), se houver mais de um.
  Future<bool> abrirRota(double latitude, double longitude) async {
    // Monta o link de navegação do Google Maps com o destino.
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$latitude,$longitude',
    );

    // 'launchUrl' abre o link. 'LaunchMode.externalApplication' garante
    // que abra no app de mapas (e não dentro do nosso app).
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // -------------------------------------------------------------------------
  // MÉTODO: ligarPara
  // -------------------------------------------------------------------------
  // Abre o discador de telefone do celular com o número já preenchido.
  // (Funcionalidade extra: Ligação Direta.)
  Future<bool> ligarPara(String telefone) async {
    // O esquema 'tel:' abre o discador.
    final Uri uri = Uri.parse('tel:$telefone');
    return await launchUrl(uri);
  }

  // -------------------------------------------------------------------------
  // MÉTODO: abrirWhatsApp
  // -------------------------------------------------------------------------
  // Abre uma conversa no WhatsApp com o número do estabelecimento.
  // (Funcionalidade extra: WhatsApp.)
  Future<bool> abrirWhatsApp(String telefone) async {
    // O link 'https://wa.me/NUMERO' abre o WhatsApp.
    // O número precisa do código do país (55 = Brasil) e só dígitos.
    final Uri uri = Uri.parse('https://wa.me/55$telefone');
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
