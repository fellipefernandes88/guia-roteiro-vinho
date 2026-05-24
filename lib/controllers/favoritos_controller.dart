// =============================================================================
// ARQUIVO: lib/controllers/favoritos_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Controller dos Favoritos (Funcionalidade 5).
//
//   RESPONSABILIDADE:
//   - Manter a lista de estabelecimentos favoritados;
//   - Adicionar e remover favoritos (usando o DatabaseService);
//   - Informar se um estabelecimento é favorito ou não.
//
//   Como os favoritos ficam no banco SQLite local, eles funcionam mesmo
//   SEM INTERNET — exatamente como o PDF do trabalho pede.
// =============================================================================

import 'package:flutter/material.dart';

import '../models/estabelecimento_model.dart';
import '../services/database_service.dart';

class FavoritosController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTA QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  final DatabaseService _databaseService = DatabaseService();

  // -------------------------------------------------------------------------
  // ESTADO
  // -------------------------------------------------------------------------

  // A lista de estabelecimentos favoritados. Começa vazia.
  List<EstabelecimentoModel> _favoritos = [];
  List<EstabelecimentoModel> get favoritos => _favoritos;

  // Indica se uma operação está em andamento.
  bool _carregando = false;
  bool get carregando => _carregando;

  // -------------------------------------------------------------------------
  // MÉTODO: carregarFavoritos
  // -------------------------------------------------------------------------
  // Busca no banco todos os favoritos salvos e atualiza a lista.
  Future<void> carregarFavoritos() async {
    _carregando = true;
    notifyListeners();

    try {
      _favoritos = await _databaseService.listarFavoritos();
    } catch (e) {
      // Em caso de erro, mantém a lista vazia (não trava o app).
      _favoritos = [];
    }

    _carregando = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: ehFavorito
  // -------------------------------------------------------------------------
  // Verifica se um estabelecimento está na lista de favoritos.
  // Aqui usamos a própria lista já carregada (mais rápido que ir ao banco).
  //
  // '.any(...)' devolve 'true' se ALGUM item da lista satisfizer a condição.
  bool ehFavorito(String estabelecimentoId) {
    return _favoritos.any((local) => local.id == estabelecimentoId);
  }

  // -------------------------------------------------------------------------
  // MÉTODO: alternarFavorito
  // -------------------------------------------------------------------------
  // Liga ou desliga o favorito de um estabelecimento:
  //   - se já é favorito, remove;
  //   - se não é, adiciona.
  // É o que acontece quando o usuário toca no ícone de coração.
  Future<void> alternarFavorito(EstabelecimentoModel estabelecimento) async {
    try {
      if (ehFavorito(estabelecimento.id)) {
        // Já é favorito -> remover.
        await _databaseService.removerFavorito(estabelecimento.id);
      } else {
        // Ainda não é favorito -> adicionar.
        await _databaseService.adicionarFavorito(estabelecimento);
      }

      // Depois de mudar, recarrega a lista para refletir o novo estado.
      await carregarFavoritos();
    } catch (e) {
      // Se falhar, apenas avisa a tela (sem travar).
      notifyListeners();
    }
  }
}
