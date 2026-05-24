# Documentação Técnica — Guia Turístico Roteiro do Vinho

Este documento explica como o projeto está organizado, para que serve cada parte e como continuar o desenvolvimento — especialmente a camada visual.

---

## 1. Visão geral da arquitetura

O projeto é organizado em **camadas**, cada uma com uma responsabilidade clara. A ideia central é separar três coisas:

- **Como** acessar recursos externos (Firebase, GPS, câmera, banco de dados) → camada de **services**.
- **O que** fazer e **quando**, mais o estado da tela → camada de **controllers**.
- **Mostrar** as informações para o usuário → camada de **screens**.

Uma frase resume a regra: *o service sabe como falar com o recurso; o controller sabe o que e quando fazer; a screen só mostra.*

Essa separação permite que duas pessoas trabalhem em paralelo: uma na lógica (services e controllers) e outra na interface (screens), sem conflito.

---

## 2. As camadas em detalhe

### models/

Classes simples que representam os dados do app. Não têm lógica — são apenas "fichas" de informação.

- `usuario_model.dart` — dados do usuário logado.
- `estabelecimento_model.dart` — dados de um estabelecimento do Roteiro do Vinho.
- `avaliacao_model.dart` — dados de uma avaliação (nota, comentário, foto). Sabe se converter para o formato do banco de dados.

### services/

Camada que acessa o "mundo externo". Cada service esconde a complexidade técnica de um recurso.

- `auth_service.dart` — login e logout com Google, via Firebase.
- `localizacao_service.dart` — acesso ao GPS: localização atual e cálculo de distância.
- `database_service.dart` — banco de dados local SQLite. Cria as tabelas e faz salvar/listar/apagar de avaliações e favoritos.
- `camera_service.dart` — abre a câmera e devolve o caminho da foto.
- `estabelecimentos_data.dart` — a lista fixa de estabelecimentos do Roteiro do Vinho.
- `conectividade_service.dart` — monitora a conexão de internet.
- `acoes_externas_service.dart` — abre apps externos (mapas, discador, WhatsApp).
- `compartilhamento_service.dart` — abre o menu nativo de compartilhamento.
- `sensor_service.dart` — detecta quando o celular é chacoalhado (acelerômetro).

### controllers/

Camada da lógica e do estado. Todos estendem `ChangeNotifier` (do pacote `provider`). Quando algo muda em um controller, ele chama `notifyListeners()` e as telas que o "escutam" se atualizam sozinhas.

- `auth_controller.dart` — controla a autenticação.
- `mapa_controller.dart` — controla o mapa e o filtro por categoria.
- `geolocalizacao_controller.dart` — controla a tela de geolocalização.
- `avaliacao_controller.dart` — controla a avaliação e o check-in georreferenciado.
- `favoritos_controller.dart` — controla a lista de favoritos.
- `conectividade_controller.dart` — mantém o estado online/offline.
- `sensor_controller.dart` — controla o sorteio por chacoalho.

### screens/

As telas que o usuário vê. **Esta é a camada que deve receber o tratamento visual final.** As telas atuais são funcionais, mas propositalmente simples — servem como base.

- `login_screen.dart` — tela de login.
- `home_screen.dart` — tela inicial, com botões para cada funcionalidade.
- `mapa_screen.dart` — mapa interativo com filtros.
- `geolocalizacao_screen.dart` — localização e estabelecimentos por distância.
- `lista_estabelecimentos_screen.dart` — lista de estabelecimentos com favoritar.
- `detalhes_estabelecimento_screen.dart` — detalhes e ações (rota, compartilhar, ligar).
- `avaliacao_screen.dart` — avaliação com check-in.
- `favoritos_screen.dart` — lista de favoritos.
- `sensor_screen.dart` — tela do chacoalhar.

### widgets/

Componentes visuais reutilizáveis.

- `mensagem_erro_widget.dart` — painel padrão de erro.
- `carregando_widget.dart` — indicador de carregamento padrão.
- `aviso_helper.dart` — exibe avisos rápidos (SnackBar).
- `conectividade_banner.dart` — faixa de "sem conexão" exibida no topo do app.

---

## 3. Como o estado funciona (Provider)

O app usa o pacote **provider** para conectar a lógica às telas.

1. No `main.dart`, os controllers são registrados com `MultiProvider` — ficam disponíveis para o app inteiro.
2. Uma tela "escuta" um controller com `context.watch<NomeDoController>()` — sempre que o controller muda, a tela se redesenha.
3. Uma tela "chama uma ação" do controller com `context.read<NomeDoController>().metodo()`.

Exceção: o `SensorController` é criado localmente pela própria `sensor_screen.dart`, para que o acelerômetro só funcione enquanto aquela tela está aberta.

---

## 4. Orientações para continuar a parte visual

A camada de **screens** é a que deve ser aprimorada visualmente. Algumas orientações para fazer isso com segurança:

- **Não é preciso alterar services nem controllers.** Toda a lógica já está pronta e testada. A interface conversa com eles apenas por `context.watch` e `context.read`.
- **Para mudar o visual de uma tela**, edite o arquivo correspondente em `screens/`. Os dados e ações continuam vindo do mesmo controller.
- **Mantenha as chamadas aos controllers.** Por exemplo, na tela de login, o botão deve continuar chamando `context.read<AuthController>().fazerLogin()`. O que pode mudar livremente é a aparência do botão, cores, fontes, imagens, layout.
- **Aproveite os widgets reutilizáveis** da pasta `widgets/` para manter consistência (mensagens de erro, carregamento).
- **Os estados a observar em cada controller** (carregando, erro, listas, etc.) estão documentados com comentários dentro de cada arquivo de controller.

---

## 5. Banco de dados local

O app usa SQLite local (pacote `sqflite`), com duas tabelas criadas em `database_service.dart`:

- **avaliacoes** — guarda as avaliações feitas pelo usuário.
- **favoritos** — guarda os estabelecimentos marcados como favoritos.

Por serem locais, avaliações e favoritos funcionam sem internet.

---

## 6. Permissões do Android

As permissões necessárias estão declaradas em `android/app/src/main/AndroidManifest.xml`:

- `INTERNET` — login e mapa.
- `ACCESS_FINE_LOCATION` e `ACCESS_COARSE_LOCATION` — GPS.
- `CAMERA` — foto na avaliação.

---

## 7. Observação sobre os dados dos estabelecimentos

A lista de estabelecimentos está em `services/estabelecimentos_data.dart`. Os nomes e telefones são reais, mas as coordenadas geográficas são aproximadas, posicionadas na região da Estrada do Vinho. Para um posicionamento exato, basta abrir o local no Google Maps e substituir as coordenadas no arquivo.
