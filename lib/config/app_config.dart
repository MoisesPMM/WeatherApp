class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.backendUsesPostgres,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://example.com/api',
      ),
      backendUsesPostgres: bool.fromEnvironment(
        'BACKEND_USES_POSTGRES',
        defaultValue: true,
      ),
    );
  }

  final String apiBaseUrl;
  final bool backendUsesPostgres;
}
