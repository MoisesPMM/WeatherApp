# WeatherApp

WeatherApp é um protótipo Flutter para consulta meteorológica por cidade, com visualização de temperatura e agregações por cidade, UF e regiões geográficas brasileiras.

## Visão geral

O app foi estruturado em camadas para manter a UI simples e separar responsabilidades:

- **Pages/widgets** renderizam a experiência Flutter.
- **Controllers** expõem estado e ações para a Home.
- **Services** concentram validações, agregações e preparação de gráficos.
- **Repositories** fazem consultas HTTP para um backend.
- **Models** representam entidades geográficas e meteorológicas.
- **Config** centraliza parâmetros como a URL da API.

## Justificativa arquitetural

Flutter mobile não deve conectar diretamente ao PostgreSQL em produção. Uma conexão direta exporia credenciais no aplicativo, dificultaria autorização por usuário e aumentaria a superfície de ataque. Por isso, este projeto usa `http` para acessar uma API/backend confiável, que por sua vez pode persistir dados em PostgreSQL. O pacote `postgres` está declarado apenas para deixar explícita a possibilidade de uso em ferramentas internas, protótipos locais ou código backend Dart, não como recomendação de conexão direta pelo app mobile.

O estado da tela é gerenciado com `provider`, os gráficos usam `fl_chart` e chamadas remotas usam `http`.

## Estrutura de pastas

- `lib/config/`: configurações da aplicação, incluindo `AppConfig` e variáveis via `--dart-define`.
- `lib/models/`: entidades de domínio usadas pelo app.
- `lib/repositories/`: camada de acesso a dados remotos via API HTTP.
- `lib/services/`: regras de negócio, validações, agregações e transformação para gráficos.
- `lib/controllers/`: estado e métodos chamados pela UI.
- `lib/pages/`: telas principais, como Splash e Home.
- `lib/widgets/`: componentes reutilizáveis, como o gráfico meteorológico.
- `test/`: testes automatizados disponíveis para o projeto.

## Entidades

- `City`: cidade consultada, associada à UF e microrregião.
- `StateUf`: unidade federativa, com sigla e macrorregião.
- `Microregion`: microrregião associada a uma mesorregião.
- `Mesoregion`: mesorregião associada a uma macrorregião.
- `Macroregion`: grande região geográfica.
- `WeatherData`: leitura meteorológica com temperatura, umidade, vento, descrição e data de observação.

## Repositories

- `GeographyRepository`: busca cidades, UFs e macrorregiões em endpoints HTTP.
- `WeatherRepository`: busca dados meteorológicos por cidade, UF e região em endpoints HTTP.

Ambos documentam que a persistência PostgreSQL deve ficar atrás de backend/API segura, evitando CRUDs genéricos e conexão direta insegura do app mobile ao banco.

## Services

- `WeatherService`: valida consultas por cidade, consulta dados meteorológicos e prepara pontos para gráficos.
- `GeographyService`: busca entidades geográficas e agrega resultados por cidade, UF e região.

## Controllers

- `WeatherController`: camada chamada pela Home para `searchByCity`, `getCityChartData`, `getUfChartData` e `getRegionChartData`.
- `GeographyController`: estado de apoio para buscas e carregamento de cidades, UFs e regiões.

## Instalação e execução

1. Instale o Flutter SDK compatível com Dart `>=3.4.0 <4.0.0`.
2. Instale dependências:

   ```bash
   flutter pub get
   ```

3. Execute o app informando a API:

   ```bash
   flutter run --dart-define=API_BASE_URL=https://seu-backend.exemplo/api
   ```

4. Rode análise e testes:

   ```bash
   flutter analyze
   flutter test
   ```

## Backend/PostgreSQL esperado

O app espera uma API HTTP com endpoints equivalentes a:

- `GET /cities?q=<cidade>`
- `GET /states`
- `GET /macroregions`
- `GET /weather/cities?name=<cidade>`
- `GET /weather/states/<UF>`
- `GET /weather/regions/<id>`

A API pode usar PostgreSQL para persistir entidades geográficas e leituras meteorológicas, mas deve aplicar autenticação, autorização, rate limiting, validação de entrada e sanitização no backend.

## Limitações do protótipo

- Endpoints são contratos esperados; a implementação real do backend não está incluída.
- As abas de UF e regiões usam chamadas demonstrativas e dependem de dados retornados pela API.
- Não há CRUD genérico de geografias ou clima, apenas busca e consulta.
- O pacote `postgres` não deve ser usado diretamente pelo app mobile em produção.

## Próximos passos

- Implementar backend/API com autenticação e persistência PostgreSQL.
- Adicionar mocks e testes de unidade para services e controllers.
- Melhorar seleção explícita de UF/região na Home.
- Configurar CI com `flutter analyze` e `flutter test`.
- Adicionar tratamento offline/cache para consultas recentes.
