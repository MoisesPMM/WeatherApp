# WeatherApp

WeatherApp é um protótipo Flutter para consultar o clima por cidade e visualizar temperaturas agregadas por cidade, unidade federativa (UF) e região brasileira.

## Arquitetura

O código-fonte adota nomes em português do Brasil e separa as responsabilidades nas seguintes camadas:

- `paginas` e `componentes`: interface do aplicativo;
- `controladores`: estado e ações consumidos pela interface;
- `servicos`: validações, agregações e preparação dos gráficos;
- `repositorios`: comunicação HTTP com o backend;
- `modelos`: entidades geográficas e meteorológicas;
- `configuracao`: parâmetros de execução, como a URL da API.

Os nomes exigidos pelo Dart, pelo Flutter ou por bibliotecas externas permanecem inalterados. Isso inclui, por exemplo, `main`, `build`, `initState`, `dispose`, `createState` e `notifyListeners`. As chaves JSON e os caminhos HTTP também continuam iguais ao contrato do backend.

## Principais classes

- `AplicativoClima`: raiz da aplicação Flutter;
- `PaginaAbertura` e `PaginaInicial`: telas do aplicativo;
- `ControladorClima` e `ControladorGeografia`: estado observável da interface;
- `ServicoClima` e `ServicoGeografia`: regras de negócio;
- `RepositorioClima` e `RepositorioGeografia`: acesso à API;
- `Cidade`, `UnidadeFederativa`, `Microrregiao`, `Mesorregiao` e `Macrorregiao`: entidades geográficas;
- `DadosMeteorologicos`: leitura de temperatura, umidade e vento;
- `GraficoClima` e `PontoGrafico`: apresentação dos dados no gráfico.

## Backend e PostgreSQL

O aplicativo não deve se conectar diretamente ao PostgreSQL em produção. Uma conexão direta exporia credenciais, dificultaria a autorização por usuário e aumentaria a superfície de ataque. O acesso ocorre por uma API confiável, que pode usar PostgreSQL internamente.

O backend deve oferecer contratos equivalentes a:

- `GET /cities?q=<cidade>`;
- `GET /states`;
- `GET /macroregions`;
- `GET /weather/cities?name=<cidade>`;
- `GET /weather/states/<UF>`;
- `GET /weather/regions/<id>`.

As chaves JSON em inglês, como `cityId`, `observedAt` e `temperatureCelsius`, são contratos externos e são convertidas para propriedades em português pelos métodos `deJson`.

## Instalação e execução

1. Instale uma versão do Flutter compatível com Dart `>=3.4.0 <4.0.0`.
2. Instale as dependências:

   ```bash
   flutter pub get
   ```

3. Execute o aplicativo informando a API:

   ```bash
   flutter run --dart-define=API_BASE_URL=https://seu-backend.exemplo/api
   ```

4. Verifique a análise estática e os testes:

   ```bash
   flutter analyze
   flutter test
   ```

## Configuração

- `API_BASE_URL`: URL-base do backend;
- `BACKEND_USES_POSTGRES`: informa se o backend usa PostgreSQL; o valor padrão é `true`.

## Limitações

- A implementação do backend não faz parte deste repositório.
- As abas de UF e região ainda usam consultas demonstrativas.
- O pacote `postgres` não deve ser usado diretamente pelo aplicativo em produção.
- Os testes de unidade dos serviços ainda precisam de clientes HTTP simulados.
