// =============================================================================
// ARQUIVO: lib/services/auth_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um "service" (serviço) é a camada que conversa com o MUNDO EXTERNO.
//   Este aqui conversa com o Firebase Authentication e com o Google.
//
// RESPONSABILIDADE (o que ele sabe fazer):
//   - Abrir a tela do Google para o usuário escolher a conta;
//   - Pedir ao Firebase para autenticar esse usuário;
//   - Fazer logout;
//   - Informar quem é o usuário logado no momento.
//
//   Frase para explicar: "O service sabe COMO falar com o Firebase. Ele esconde
//   toda a parte técnica para que o resto do app não precise se preocupar."
// =============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // -------------------------------------------------------------------------
  // FERRAMENTAS QUE O SERVICE USA
  // -------------------------------------------------------------------------
  // '_auth' é a porta de entrada do Firebase Authentication.
  // O '_' no início do nome significa que é PRIVADO (só usado dentro deste arquivo).
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -------------------------------------------------------------------------
  // INICIALIZAÇÃO DO GOOGLE SIGN-IN
  // -------------------------------------------------------------------------
  // A partir da versão 7 do pacote google_sign_in, antes de usar o login
  // é preciso "inicializar" a ferramenta uma vez. Guardamos aqui se isso
  // já foi feito, para não repetir.
  bool _googleInicializado = false;

  // Método que garante que o Google Sign-In está pronto para uso.
  Future<void> _garantirGoogleInicializado() async {
    // Se já inicializou antes, não faz nada e sai.
    if (_googleInicializado) return;

    // 'initialize()' prepara o pacote google_sign_in para funcionar.
    await GoogleSignIn.instance.initialize();
    _googleInicializado = true;
  }

  // -------------------------------------------------------------------------
  // MÉTODO: usuarioAtual
  // -------------------------------------------------------------------------
  // Devolve o usuário que está logado AGORA, ou 'null' se ninguém estiver.
  // O Firebase guarda essa informação automaticamente, mesmo se fechar o app.
  User? get usuarioAtual => _auth.currentUser;

  // -------------------------------------------------------------------------
  // MÉTODO: mudancasDeAutenticacao
  // -------------------------------------------------------------------------
  // É um "fluxo" (Stream) que avisa toda vez que o login muda:
  // quando alguém entra, devolve o usuário; quando alguém sai, devolve null.
  // Usaremos isso para o app saber sozinho se deve mostrar a tela de login
  // ou a tela principal.
  Stream<User?> get mudancasDeAutenticacao => _auth.authStateChanges();

  // -------------------------------------------------------------------------
  // MÉTODO: loginComGoogle
  // -------------------------------------------------------------------------
  // Faz todo o processo de login com a conta Google.
  // Devolve o 'User' do Firebase em caso de sucesso, ou 'null' se o usuário
  // cancelar (fechar a janela de escolha de conta sem escolher).
  Future<User?> loginComGoogle() async {
    // Passo 1: garantir que o Google Sign-In está pronto.
    await _garantirGoogleInicializado();

    // Passo 2: abrir a tela do Google para o usuário escolher a conta.
    // 'authenticate()' mostra a janela nativa de seleção de conta.
    final GoogleSignInAccount contaGoogle =
        await GoogleSignIn.instance.authenticate();

    // Passo 3: pegar o "crachá de identidade" (token) dessa conta Google.
    // O Firebase precisa desse token para confiar que o login é verdadeiro.
    final GoogleSignInAuthentication autenticacaoGoogle =
        contaGoogle.authentication;

    // Passo 4: montar a "credencial" no formato que o Firebase entende.
    final OAuthCredential credencial = GoogleAuthProvider.credential(
      idToken: autenticacaoGoogle.idToken,
    );

    // Passo 5: entregar a credencial ao Firebase para concluir o login.
    // O Firebase valida e cria/recupera a conta do usuário.
    final UserCredential resultado =
        await _auth.signInWithCredential(credencial);

    // Passo 6: devolver o usuário autenticado.
    return resultado.user;
  }

  // -------------------------------------------------------------------------
  // MÉTODO: logout
  // -------------------------------------------------------------------------
  // Desconecta o usuário tanto do Firebase quanto do Google.
  Future<void> logout() async {
    // Desconecta da conta Google (limpa a escolha de conta).
    await _garantirGoogleInicializado();
    await GoogleSignIn.instance.signOut();

    // Desconecta do Firebase (encerra a sessão).
    await _auth.signOut();
  }
}
