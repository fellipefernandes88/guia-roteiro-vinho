// =============================================================================
// ARQUIVO: lib/screens/login_screen.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Uma "screen" (tela) é o que o usuário VÊ e TOCA.
//   Esta é a tela de login. Ela é proposital e intencionalmente SIMPLES
//   (uma tela de teste), porque outra pessoa do grupo vai cuidar do visual.
//
//   O importante aqui: a tela NÃO sabe falar com o Firebase. Ela apenas
//   chama o AuthController e "escuta" o que ele responde.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 'context.watch' faz esta tela "OUVIR" o AuthController.
    // Sempre que o controller chamar 'notifyListeners()', esta tela se redesenha.
    final AuthController auth = context.watch<AuthController>();

    return Scaffold(
      // 'Scaffold' é a estrutura básica de uma tela (barra, corpo, etc.).
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        // 'Center' coloca o conteúdo no meio da tela.
        child: Padding(
          padding: const EdgeInsets.all(24.0), // espaçamento nas bordas.
          child: Column(
            // 'Column' empilha os elementos de cima para baixo.
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------------------------------------------------------
              // TÍTULO
              // ---------------------------------------------------------------
              const Icon(Icons.wine_bar, size: 80),
              const SizedBox(height: 16), // espaço vazio entre elementos.
              const Text(
                'Guia Turístico\nRoteiro do Vinho',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // ---------------------------------------------------------------
              // ÁREA QUE MUDA: carregando OU botão de login
              // ---------------------------------------------------------------
              // Se o controller estiver 'carregando', mostramos um círculo
              // girando. Senão, mostramos o botão de login.
              if (auth.carregando)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar com Google'),
                  // 'onPressed' é o que acontece ao tocar no botão.
                  onPressed: () {
                    // 'context.read' pega o controller só para CHAMAR um
                    // método (diferente de 'watch', que fica ouvindo).
                    context.read<AuthController>().fazerLogin();
                  },
                ),

              // ---------------------------------------------------------------
              // MENSAGEM DE ERRO (só aparece se houver erro)
              // ---------------------------------------------------------------
              if (auth.erro != null) ...[
                const SizedBox(height: 20),
                Text(
                  auth.erro!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
