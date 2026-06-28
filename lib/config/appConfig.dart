class ConfiguracaoAplicativo {
  const ConfiguracaoAplicativo({
    required this.urlBaseApi,
    required this.backendUsaPostgres,
  });

  factory ConfiguracaoAplicativo.doAmbiente() {
    return const ConfiguracaoAplicativo(
      urlBaseApi: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: '',
      ),
      backendUsaPostgres: bool.fromEnvironment(
        'BACKEND_USES_POSTGRES',
        defaultValue: true,
      ),
    );
  }

  final String urlBaseApi;
  final bool backendUsaPostgres;
}
