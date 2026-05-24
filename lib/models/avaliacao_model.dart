// =============================================================================
// ARQUIVO: lib/models/avaliacao_model.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Modelo que representa uma AVALIAÇÃO feita pelo usuário sobre um
//   estabelecimento.
//
//   Guarda: qual estabelecimento, a nota (1 a 5), o comentário, o caminho
//   da foto tirada e a data da avaliação.
//
//   Este modelo também sabe se converter para o formato do banco de dados
//   (um "Map") e voltar — porque o SQLite trabalha com Maps, não com objetos.
// =============================================================================

class AvaliacaoModel {
  // -------------------------------------------------------------------------
  // ATRIBUTOS
  // -------------------------------------------------------------------------
  // 'id' é o número da avaliação no banco. É opcional ('int?') porque, ao
  // CRIAR uma avaliação nova, ainda não temos id — o banco gera ele sozinho.
  final int? id;
  final String estabelecimentoId; // qual estabelecimento foi avaliado.
  final String estabelecimentoNome; // nome dele (guardado para facilitar).
  final int nota; // nota de 1 a 5.
  final String comentario; // texto escrito pelo usuário.
  final String? fotoCaminho; // caminho do arquivo da foto no celular (opcional).
  final String data; // data/hora da avaliação, guardada como texto.

  // -------------------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------------------
  AvaliacaoModel({
    this.id,
    required this.estabelecimentoId,
    required this.estabelecimentoNome,
    required this.nota,
    required this.comentario,
    this.fotoCaminho,
    required this.data,
  });

  // -------------------------------------------------------------------------
  // MÉTODO: toMap
  // -------------------------------------------------------------------------
  // Converte este objeto em um 'Map' (uma estrutura de chave→valor).
  // O SQLite só sabe salvar Maps, então precisamos traduzir o objeto.
  //
  // As chaves ('estabelecimento_id', 'nota', etc.) são os NOMES DAS COLUNAS
  // da tabela no banco de dados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estabelecimento_id': estabelecimentoId,
      'estabelecimento_nome': estabelecimentoNome,
      'nota': nota,
      'comentario': comentario,
      'foto_caminho': fotoCaminho,
      'data': data,
    };
  }

  // -------------------------------------------------------------------------
  // CONSTRUTOR DE FÁBRICA: fromMap
  // -------------------------------------------------------------------------
  // Faz o caminho inverso do 'toMap': pega um Map vindo do banco de dados
  // e monta um objeto AvaliacaoModel a partir dele.
  //
  // 'factory' é um tipo especial de construtor que pode "fabricar" o objeto.
  factory AvaliacaoModel.fromMap(Map<String, dynamic> map) {
    return AvaliacaoModel(
      id: map['id'] as int?,
      estabelecimentoId: map['estabelecimento_id'] as String,
      estabelecimentoNome: map['estabelecimento_nome'] as String,
      nota: map['nota'] as int,
      comentario: map['comentario'] as String,
      fotoCaminho: map['foto_caminho'] as String?,
      data: map['data'] as String,
    );
  }
}
