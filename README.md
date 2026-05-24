# Guia Turístico — Roteiro do Vinho (São Roque/SP)

Aplicativo mobile desenvolvido em **Flutter** para a disciplina de Desenvolvimento Mobile da Fatec. Funciona como um guia turístico digital do Roteiro do Vinho de São Roque, permitindo localizar estabelecimentos, avaliá-los, salvá-los como favoritos e utilizar recursos nativos do smartphone.

## Funcionalidades

### Obrigatórias

1. **Autenticação com Google** — login, persistência de sessão e logout, via Firebase Authentication.
2. **Mapa Interativo** — mapa OpenStreetMap com marcadores dos estabelecimentos e localização do usuário.
3. **Geolocalização** — captura a localização atual e calcula a distância até cada estabelecimento.
4. **Sistema de Avaliação** — nota de 1 a 5, comentário e foto pela câmera, salvos em banco local.
5. **Favoritos** — salva estabelecimentos favoritos localmente, com acesso offline.
6. **Tratamento de Erros** — o app trata ausência de internet, GPS desativado, permissões negadas e falhas, sem travamentos.
7. **Monitoramento de Conectividade** — faixa visual avisa quando o dispositivo está offline.

### Extras

- **Abertura de Rotas** — botão "Como Chegar" abre o app de mapas.
- **Compartilhamento Nativo** — compartilha o estabelecimento via apps do celular.
- **Ligação / WhatsApp** — abre o discador ou uma conversa no WhatsApp.
- **Check-in Georreferenciado** — só permite avaliar quem está a no máximo 100 m do local.
- **Filtros no Mapa** — filtra os marcadores por categoria.
- **Sensores do Dispositivo** — chacoalhar o celular sorteia um estabelecimento (acelerômetro).

## Tecnologias

- **Flutter** (Dart)
- **Firebase Authentication** + **google_sign_in** — autenticação
- **flutter_map** + **latlong2** — mapa
- **geolocator** — GPS
- **sqflite** — banco de dados local (avaliações e favoritos)
- **image_picker** — câmera
- **provider** — gerenciamento de estado
- **connectivity_plus** — monitoramento de conexão
- **url_launcher** + **share_plus** — ações externas e compartilhamento
- **sensors_plus** — acelerômetro

## Estrutura do projeto

```
lib/
├── main.dart            # Ponto de entrada do app
├── firebase_options.dart# Configuração do Firebase (gerado)
├── models/              # Modelos de dados (usuário, estabelecimento, avaliação)
├── services/            # Acesso a recursos externos (Firebase, GPS, banco, etc.)
├── controllers/         # Lógica e estado das telas (Provider / ChangeNotifier)
├── screens/             # Telas do aplicativo
└── widgets/             # Componentes visuais reutilizáveis
```

A arquitetura separa responsabilidades em camadas: os **services** acessam recursos externos, os **controllers** contêm a lógica e o estado, e as **screens** apenas exibem. Veja detalhes em `DOCUMENTACAO.md`.

## Como executar

Pré-requisitos: Flutter SDK instalado e um dispositivo Android (físico ou emulador).

```bash
# 1. Clonar o repositório
git clone https://github.com/fellipefernandes88/guia-roteiro-vinho.git
cd guia-roteiro-vinho

# 2. Baixar as dependências
flutter pub get

# 3. Executar em um dispositivo conectado
flutter run
```

> O login Google depende de um certificado SHA-1 cadastrado no Firebase. Para rodar em outra máquina, pode ser necessário cadastrar o SHA-1 daquela máquina no console do Firebase.

## Entrega

Projeto desenvolvido como atividade avaliativa prática da disciplina de Desenvolvimento Mobile — Fatec São Roque.
