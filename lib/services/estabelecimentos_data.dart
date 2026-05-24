// =============================================================================
// ARQUIVO: lib/services/estabelecimentos_data.dart
// -----------------------------------------------------------------------------
// O QUE É:
//   A "fonte de dados" local dos estabelecimentos do Roteiro do Vinho.
//
//   Em vez de buscar os locais em um banco de dados na nuvem, mantemos a lista
//   aqui, fixa no código. Vantagens: simples, funciona SEM INTERNET e é
//   fácil de explicar.
//
// IMPORTANTE SOBRE AS COORDENADAS:
//   Os nomes e telefones são reais. As coordenadas (latitude/longitude) são
//   APROXIMADAS, posicionadas na região da Estrada do Vinho em São Roque/SP.
//   Para um posicionamento exato, basta abrir o local no Google Maps, copiar
//   as coordenadas e substituí-las abaixo.
// =============================================================================

import '../models/estabelecimento_model.dart';

// 'EstabelecimentosData' é uma classe que só serve para guardar a lista.
class EstabelecimentosData {
  // -------------------------------------------------------------------------
  // LISTA DE ESTABELECIMENTOS
  // -------------------------------------------------------------------------
  // 'static' significa que a lista pertence à classe (não a um objeto).
  // Assim podemos acessá-la diretamente: EstabelecimentosData.lista
  //
  // 'const' significa que a lista é fixa e não muda durante a execução.
  static final List<EstabelecimentoModel> lista = [
    EstabelecimentoModel(
      id: '1',
      nome: 'Vinícola Góes',
      categoria: 'Vinícola',
      latitude: -23.5012,
      longitude: -47.0985,
      telefone: '1146020100',
      descricao:
          'A maior e mais tradicional vinícola de São Roque, fundada por '
          'imigrantes portugueses. Oferece visitas guiadas e degustação.',
    ),
    EstabelecimentoModel(
      id: '2',
      nome: 'Quinta do Olivardo',
      categoria: 'Vinícola',
      latitude: -23.5089,
      longitude: -47.1042,
      telefone: '1147121888',
      descricao:
          'Vinícola com forte tradição portuguesa, conhecida pela gastronomia '
          'típica e pelo famoso festival do bacalhau.',
    ),
    EstabelecimentoModel(
      id: '3',
      nome: 'Vinhos XV de Novembro',
      categoria: 'Vinícola',
      latitude: -23.4955,
      longitude: -47.0921,
      telefone: '1147121515',
      descricao:
          'Vinícola familiar com rótulos premiados e um aconchegante espaço '
          'para degustação no coração do Roteiro do Vinho.',
    ),
    EstabelecimentoModel(
      id: '4',
      nome: 'Vinhas Santa Cecília',
      categoria: 'Vinícola',
      latitude: -23.5134,
      longitude: -47.1108,
      telefone: '1199620121',
      descricao:
          'Ambiente acolhedor que oferece degustação de vinhos e produtos '
          'artesanais, como doces e queijos de Minas Gerais.',
    ),
    EstabelecimentoModel(
      id: '5',
      nome: 'Restaurante Quinta dos Guimarães',
      categoria: 'Restaurante',
      latitude: -23.5067,
      longitude: -47.0998,
      telefone: '1147125050',
      descricao:
          'Restaurante com mais de 75 anos de tradição, unindo a culinária '
          'portuguesa aos vinhos da casa Santa Terezinha.',
    ),
    EstabelecimentoModel(
      id: '6',
      nome: 'Cafeteria Casa da Árvore',
      categoria: 'Cafeteria',
      latitude: -23.4998,
      longitude: -47.1065,
      telefone: '1199787058',
      descricao:
          'Espaço charmoso em meio à Mata Atlântica, com vinhos, sucos e '
          'espumantes artesanais, além de uma cafeteria à beira do lago.',
    ),
    EstabelecimentoModel(
      id: '7',
      nome: 'Adega Terra do Vinho',
      categoria: 'Adega',
      latitude: -23.5156,
      longitude: -47.0954,
      telefone: '1147122323',
      descricao:
          'Adega tradicional com ampla variedade de rótulos da região e '
          'um empório com produtos típicos para levar para casa.',
    ),
    EstabelecimentoModel(
      id: '8',
      nome: 'Pousada Recanto das Videiras',
      categoria: 'Pousada',
      latitude: -23.5023,
      longitude: -47.1123,
      telefone: '1147129090',
      descricao:
          'Pousada aconchegante cercada por videiras, ideal para quem deseja '
          'descansar e aproveitar o Roteiro do Vinho com calma.',
    ),
  ];
}
