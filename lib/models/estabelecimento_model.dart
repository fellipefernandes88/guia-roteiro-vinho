// =============================================================================
// ARQUIVO: lib/models/estabelecimento_model.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Modelo que representa um ESTABELECIMENTO do Roteiro do Vinho
//   (uma vinícola, restaurante, cafeteria ou pousada).
//
//   É a "ficha" de cada local: guarda nome, categoria, onde fica (coordenadas),
//   telefone e descrição. As telas (mapa, lista, detalhes) leem esta ficha.
// =============================================================================

class EstabelecimentoModel {
  // -------------------------------------------------------------------------
  // ATRIBUTOS
  // -------------------------------------------------------------------------
  final String id; // identificador único do estabelecimento.
  final String nome; // nome do local (ex: "Vinícola Góes").
  final String categoria; // tipo do local (ex: "Vinícola", "Restaurante").
  final double latitude; // coordenada geográfica (linha horizontal do mapa).
  final double longitude; // coordenada geográfica (linha vertical do mapa).
  final String telefone; // telefone de contato (apenas números).
  final String descricao; // texto curto descrevendo o local.

  // -------------------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------------------
  // Todos os campos são obrigatórios ('required') ao criar um estabelecimento.
  EstabelecimentoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.latitude,
    required this.longitude,
    required this.telefone,
    required this.descricao,
  });
}
