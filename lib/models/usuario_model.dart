// =============================================================================
// ARQUIVO: lib/models/usuario_model.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Um "modelo" (model) é uma classe simples que representa um dado do app.
//   Aqui, ela representa o USUÁRIO que fez login com a conta Google.
//
// POR QUE EXISTE:
//   O Firebase nos devolve um objeto cheio de informações técnicas. Em vez de
//   espalhar esse objeto complicado pelo app inteiro, nós copiamos só o que
//   interessa (nome, e-mail e foto) para dentro desta classe nossa, mais
//   simples e fácil de usar nas telas.
//
//   Frase para explicar: "O model é uma 'ficha' organizada com os dados do
//   usuário. As telas leem essa ficha, sem precisar entender o Firebase."
// =============================================================================

class UsuarioModel {
  // -------------------------------------------------------------------------
  // ATRIBUTOS (as informações que guardamos sobre o usuário)
  // -------------------------------------------------------------------------
  // 'final' significa que, depois de criado, o valor não muda mais.
  final String id; // identificador único do usuário (gerado pelo Firebase)
  final String nome; // nome de exibição da conta Google
  final String email; // e-mail da conta Google
  final String? fotoUrl; // endereço (URL) da foto de perfil.
  // O '?' indica que pode ser NULO (o usuário pode não ter foto).

  // -------------------------------------------------------------------------
  // CONSTRUTOR
  // -------------------------------------------------------------------------
  // É o "molde" usado para criar um objeto UsuarioModel.
  // 'required' obriga a informar o valor ao criar (exceto fotoUrl, que é opcional).
  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
  });
}
