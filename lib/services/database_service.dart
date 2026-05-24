// =============================================================================
// ARQUIVO: lib/services/database_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   O service que gerencia o BANCO DE DADOS LOCAL (SQLite) do aplicativo.
//
//   É o "coração" da persistência local. Ele:
//   - Cria o arquivo do banco de dados no celular;
//   - Cria as tabelas (avaliações e favoritos);
//   - Oferece métodos para salvar, listar e apagar registros.
//
//   Usa o pacote 'sqflite' (o SQLite do Flutter).
//
//   OBSERVAÇÃO: este service atende a Funcionalidade 4 (Avaliações) e a
//   Funcionalidade 5 (Favoritos). Por isso ele cria as duas tabelas.
// =============================================================================

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/avaliacao_model.dart';
import '../models/estabelecimento_model.dart';

class DatabaseService {
  // -------------------------------------------------------------------------
  // PADRÃO SINGLETON
  // -------------------------------------------------------------------------
  // Queremos UMA ÚNICA conexão com o banco no app inteiro (abrir o banco
  // várias vezes causa problemas). O padrão "singleton" garante isso.
  static final DatabaseService _instancia = DatabaseService._interno();

  // O construtor 'factory' sempre devolve a mesma instância já criada.
  factory DatabaseService() => _instancia;

  // Construtor privado de verdade (só usado uma vez, internamente).
  DatabaseService._interno();

  // -------------------------------------------------------------------------
  // A CONEXÃO COM O BANCO
  // -------------------------------------------------------------------------
  // '_database' guarda a conexão. Começa nula; é criada na primeira vez
  // que for necessária.
  static Database? _database;

  // 'get database' devolve a conexão. Se ainda não existir, cria.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _abrirBanco();
    return _database!;
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _abrirBanco
  // -------------------------------------------------------------------------
  // Abre o arquivo do banco de dados. Se for a primeira vez (arquivo não
  // existe), o sqflite chama o 'onCreate' para montarmos as tabelas.
  Future<Database> _abrirBanco() async {
    // Descobre a pasta onde o app pode guardar bancos de dados.
    final String pastaBanco = await getDatabasesPath();

    // Monta o caminho completo do arquivo do banco.
    final String caminho = join(pastaBanco, 'guia_roteiro_vinho.db');

    // Abre o banco no caminho indicado.
    return await openDatabase(
      caminho,
      version: 1, // versão do banco (usada para futuras atualizações).
      onCreate: _criarTabelas, // o que rodar quando o banco é criado.
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _criarTabelas
  // -------------------------------------------------------------------------
  // Roda UMA VEZ, quando o banco é criado pela primeira vez.
  Future<void> _criarTabelas(Database db, int versao) async {
    // --- Tabela de AVALIAÇÕES ---
    await db.execute('''
      CREATE TABLE avaliacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estabelecimento_id TEXT NOT NULL,
        estabelecimento_nome TEXT NOT NULL,
        nota INTEGER NOT NULL,
        comentario TEXT NOT NULL,
        foto_caminho TEXT,
        data TEXT NOT NULL
      )
    ''');

    // --- Tabela de FAVORITOS ---
    // Guarda os dados do estabelecimento favoritado.
    // 'estabelecimento_id' é a PRIMARY KEY: garante que um mesmo
    // estabelecimento não seja favoritado duas vezes.
    await db.execute('''
      CREATE TABLE favoritos (
        estabelecimento_id TEXT PRIMARY KEY,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        telefone TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    ''');
  }

  // ===========================================================================
  // OPERAÇÕES DA TABELA DE AVALIAÇÕES
  // ===========================================================================

  // -------------------------------------------------------------------------
  // MÉTODO: salvarAvaliacao
  // -------------------------------------------------------------------------
  // Insere uma nova avaliação na tabela.
  Future<void> salvarAvaliacao(AvaliacaoModel avaliacao) async {
    final Database db = await database;
    await db.insert('avaliacoes', avaliacao.toMap());
  }

  // -------------------------------------------------------------------------
  // MÉTODO: listarAvaliacoesPorEstabelecimento
  // -------------------------------------------------------------------------
  // Devolve todas as avaliações de um estabelecimento específico.
  Future<List<AvaliacaoModel>> listarAvaliacoesPorEstabelecimento(
    String estabelecimentoId,
  ) async {
    final Database db = await database;

    final List<Map<String, dynamic>> linhas = await db.query(
      'avaliacoes',
      where: 'estabelecimento_id = ?',
      whereArgs: [estabelecimentoId],
      orderBy: 'data DESC',
    );

    return linhas.map((linha) => AvaliacaoModel.fromMap(linha)).toList();
  }

  // ===========================================================================
  // OPERAÇÕES DA TABELA DE FAVORITOS
  // ===========================================================================

  // -------------------------------------------------------------------------
  // MÉTODO: adicionarFavorito
  // -------------------------------------------------------------------------
  // Salva um estabelecimento como favorito.
  Future<void> adicionarFavorito(EstabelecimentoModel estabelecimento) async {
    final Database db = await database;

    // Monta o Map com os dados do estabelecimento (as colunas da tabela).
    final Map<String, dynamic> dados = {
      'estabelecimento_id': estabelecimento.id,
      'nome': estabelecimento.nome,
      'categoria': estabelecimento.categoria,
      'latitude': estabelecimento.latitude,
      'longitude': estabelecimento.longitude,
      'telefone': estabelecimento.telefone,
      'descricao': estabelecimento.descricao,
    };

    // 'insert' adiciona a linha. 'conflictAlgorithm: replace' significa:
    // se o estabelecimento já estiver favoritado, apenas substitui (não
    // dá erro de chave duplicada).
    await db.insert(
      'favoritos',
      dados,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: removerFavorito
  // -------------------------------------------------------------------------
  // Remove um estabelecimento da lista de favoritos.
  Future<void> removerFavorito(String estabelecimentoId) async {
    final Database db = await database;

    // 'delete' apaga linhas. 'where' indica qual linha apagar.
    await db.delete(
      'favoritos',
      where: 'estabelecimento_id = ?',
      whereArgs: [estabelecimentoId],
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: listarFavoritos
  // -------------------------------------------------------------------------
  // Devolve todos os estabelecimentos favoritados.
  Future<List<EstabelecimentoModel>> listarFavoritos() async {
    final Database db = await database;

    // Busca todas as linhas da tabela 'favoritos'.
    final List<Map<String, dynamic>> linhas = await db.query('favoritos');

    // Converte cada linha do banco em um EstabelecimentoModel.
    return linhas.map((linha) {
      return EstabelecimentoModel(
        id: linha['estabelecimento_id'] as String,
        nome: linha['nome'] as String,
        categoria: linha['categoria'] as String,
        latitude: linha['latitude'] as double,
        longitude: linha['longitude'] as double,
        telefone: linha['telefone'] as String,
        descricao: linha['descricao'] as String,
      );
    }).toList();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: ehFavorito
  // -------------------------------------------------------------------------
  // Verifica se um estabelecimento específico está nos favoritos.
  // Devolve 'true' se estiver, 'false' se não.
  Future<bool> ehFavorito(String estabelecimentoId) async {
    final Database db = await database;

    // Busca a linha com aquele id.
    final List<Map<String, dynamic>> linhas = await db.query(
      'favoritos',
      where: 'estabelecimento_id = ?',
      whereArgs: [estabelecimentoId],
    );

    // Se a busca trouxe alguma linha, o estabelecimento é favorito.
    return linhas.isNotEmpty;
  }
}
