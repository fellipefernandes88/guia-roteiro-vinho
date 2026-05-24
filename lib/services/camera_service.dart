// =============================================================================
// ARQUIVO: lib/services/camera_service.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   Service que conversa com a CÂMERA do dispositivo, usando o pacote
//   'image_picker'.
//
//   RESPONSABILIDADE:
//   - Abrir a câmera do celular;
//   - Devolver o caminho do arquivo da foto tirada.
//
//   OBSERVAÇÃO: não guardamos a imagem em si, e sim o CAMINHO do arquivo
//   (onde a foto está salva no celular). É mais leve e é a forma recomendada.
// =============================================================================

import 'package:image_picker/image_picker.dart';

class CameraService {
  // A ferramenta do pacote image_picker que abre a câmera/galeria.
  final ImagePicker _picker = ImagePicker();

  // -------------------------------------------------------------------------
  // MÉTODO: tirarFoto
  // -------------------------------------------------------------------------
  // Abre a câmera do celular para o usuário tirar uma foto.
  //
  // Devolve:
  //   - o CAMINHO do arquivo da foto, se o usuário tirou a foto;
  //   - 'null', se o usuário cancelou (fechou a câmera sem tirar).
  Future<String?> tirarFoto() async {
    // 'pickImage' abre a câmera. 'source: ImageSource.camera' indica que
    // queremos a CÂMERA (e não a galeria de fotos).
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      // 'imageQuality' reduz um pouco a qualidade para a foto não ficar
      // pesada demais (80 de 100 é um bom equilíbrio).
      imageQuality: 80,
    );

    // Se o usuário cancelou, 'foto' vem nulo.
    if (foto == null) {
      return null;
    }

    // 'foto.path' é o caminho do arquivo da imagem no celular.
    return foto.path;
  }
}
