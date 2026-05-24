// =============================================================================
// ARQUIVO: lib/controllers/auth_controller.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um "controller" é a camada que CONTROLA a lógica e GUARDA O ESTADO da tela.
//   Este controla a autenticação.
//
//   Ele usa 'ChangeNotifier', que é a base do pacote 'provider'.
//   'ChangeNotifier' funciona como uma estação de rádio: quando algo muda
//   aqui dentro, ele "transmite" um aviso, e as telas que estão "ouvindo"
//   se atualizam sozinhas.
//
//   Frase para explicar: "O controller decide O QUE fazer e QUANDO. Ele usa o
//   service para a parte técnica, e avisa as telas quando algo muda."
// =============================================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../models/usuario_model.dart';

class AuthController extends ChangeNotifier {
  // -------------------------------------------------------------------------
  // FERRAMENTA QUE O CONTROLLER USA
  // -------------------------------------------------------------------------
  // O controller não fala direto com o Firebase. Ele pede para o service.
  final AuthService _authService = AuthService();

  // -------------------------------------------------------------------------
  // ESTADO (as informações que a tela precisa saber)
  // -------------------------------------------------------------------------

  // Guarda o usuário logado. Fica 'null' quando ninguém está logado.
  UsuarioModel? _usuario;
  UsuarioModel? get usuario => _usuario; // forma de a tela LER o usuário.

  // Indica se uma operação está em andamento (ex: login acontecendo).
  // A tela usa isso para mostrar um círculo de "carregando".
  bool _carregando = false;
  bool get carregando => _carregando;

  // Guarda uma mensagem de erro, se algo deu errado. 'null' = sem erro.
  String? _erro;
  String? get erro => _erro;

  // Atalho prático: devolve 'true' se existe alguém logado.
  bool get estaLogado => _usuario != null;

  // -------------------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------------------
  // Assim que o controller é criado, ele já verifica se existe uma sessão
  // salva (alguém que logou antes e não saiu). Isso é a "persistência de
  // sessão" que o trabalho pede.
  AuthController() {
    _verificarSessaoExistente();
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _verificarSessaoExistente
  // -------------------------------------------------------------------------
  // O Firebase guarda automaticamente quem estava logado, mesmo depois de
  // fechar o app. Aqui nós perguntamos ao service se há alguém e, se houver,
  // preenchemos o estado.
  void _verificarSessaoExistente() {
    final User? usuarioFirebase = _authService.usuarioAtual;
    if (usuarioFirebase != null) {
      _usuario = _converterParaModel(usuarioFirebase);
    }
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRIVADO: _converterParaModel
  // -------------------------------------------------------------------------
  // Pega o objeto complicado do Firebase ('User') e copia só o que interessa
  // para dentro do nosso modelo simples ('UsuarioModel').
  UsuarioModel _converterParaModel(User usuarioFirebase) {
    return UsuarioModel(
      id: usuarioFirebase.uid,
      // Se o nome vier vazio, usamos um texto padrão (?? significa "ou isto").
      nome: usuarioFirebase.displayName ?? 'Sem nome',
      email: usuarioFirebase.email ?? 'Sem e-mail',
      fotoUrl: usuarioFirebase.photoURL,
    );
  }

  // -------------------------------------------------------------------------
  // MÉTODO: fazerLogin
  // -------------------------------------------------------------------------
  // Chamado quando o usuário toca no botão "Entrar com Google".
  Future<void> fazerLogin() async {
    // 1) Liga o "carregando" e limpa erros antigos.
    _carregando = true;
    _erro = null;
    notifyListeners(); // avisa a tela: "estou carregando, mostre o círculo".

    // 2) 'try/catch' tenta executar e, se der erro, captura sem travar o app.
    try {
      // Pede ao service para fazer o login com Google.
      final User? usuarioFirebase = await _authService.loginComGoogle();

      if (usuarioFirebase != null) {
        // Sucesso: converte e guarda o usuário.
        _usuario = _converterParaModel(usuarioFirebase);
      } else {
        // O usuário fechou a janela do Google sem escolher conta.
        _erro = 'Login cancelado.';
      }
    } catch (e) {
      // Algo deu errado (sem internet, configuração, etc.).
      _erro = 'Falha ao fazer login. Tente novamente.';
    }

    // 3) Desliga o "carregando" e avisa a tela do resultado final.
    _carregando = false;
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // MÉTODO: fazerLogout
  // -------------------------------------------------------------------------
  // Chamado quando o usuário toca no botão "Sair".
  Future<void> fazerLogout() async {
    _carregando = true;
    notifyListeners();

    try {
      await _authService.logout(); // pede ao service para desconectar.
      _usuario = null; // limpa o usuário do estado.
    } catch (e) {
      _erro = 'Falha ao sair. Tente novamente.';
    }

    _carregando = false;
    notifyListeners();
  }
}
