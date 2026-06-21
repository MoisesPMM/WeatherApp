import 'package:flutter/foundation.dart';

import '../models/city.dart';
import '../models/macroregion.dart';
import '../models/state_uf.dart';
import '../services/geography_service.dart';

class GeographyController extends ChangeNotifier {
  GeographyController({required GeographyService service}) : _service = service;

  final GeographyService _service;

  List<City> cities = const [];
  List<StateUf> states = const [];
  List<Macroregion> macroregions = const [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> searchCities(String query) async {
    await _run(() async {
      cities = await _service.searchCities(query);
    });
  }

  Future<void> loadRegions() async {
    await _run(() async {
      states = await _service.getStates();
      macroregions = await _service.getMacroregions();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      errorMessage = 'Não foi possível carregar geografias: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
