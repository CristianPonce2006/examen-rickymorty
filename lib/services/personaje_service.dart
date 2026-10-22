import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/personaje.dart';
import '../models/resultado_paginado.dart';
import 'favorite_service.dart';

class PersonajeService {
  /// Obtiene una página del catálogo general aprovechando la paginación remota de la API
  Future<ResultadoPaginado<Personaje>> getPersonajes({int page = 1}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/character?page=$page');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final Map<String, dynamic> info = data['info'] as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;

      final personajes =
          results.map((json) => Personaje.fromJson(json as Map<String, dynamic>)).toList();

      return ResultadoPaginado<Personaje>(
        items: personajes,
        totalPaginas: info['pages'] as int? ?? 1,
        tieneSiguiente: info['next'] != null,
      );
    } else {
      throw Exception('Error al cargar personajes: HTTP ${response.statusCode}');
    }
  }

  /// Pagina una lista completa de IDs localmente y consulta únicamente los elementos
  /// necesarios para la página dada
  Future<ResultadoPaginado<Personaje>> getPersonajesPorIds(
    List<String> allIds, {
    int page = 1,
    int pageSize = 10,
  }) async {
    if (allIds.isEmpty) {
      return ResultadoPaginado<Personaje>(
        items: [],
        totalPaginas: 0,
        tieneSiguiente: false,
      );
    }

    final int totalPaginas = (allIds.length / pageSize).ceil();
    final bool tieneSiguiente = page < totalPaginas;

    final startIndex = (page - 1) * pageSize;
    if (startIndex >= allIds.length || startIndex < 0) {
      return ResultadoPaginado<Personaje>(
        items: [],
        totalPaginas: totalPaginas,
        tieneSiguiente: false,
      );
    }

    final endIndex = (startIndex + pageSize > allIds.length)
        ? allIds.length
        : startIndex + pageSize;

    final List<String> pageIds = allIds.sublist(startIndex, endIndex);

    final url = Uri.parse(ApiConfig.charactersByIds(pageIds));
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Personaje> personajes;

      if (pageIds.length == 1) {
        personajes = [Personaje.fromJson(data as Map<String, dynamic>)];
      } else {
        personajes = (data as List<dynamic>)
            .map((json) => Personaje.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return ResultadoPaginado<Personaje>(
        items: personajes,
        totalPaginas: totalPaginas,
        tieneSiguiente: tieneSiguiente,
      );
    } else {
      throw Exception('Error al cargar favoritos: HTTP ${response.statusCode}');
    }
  }
}

/// Gestor de estado (Provider) que conecta las interfaces con el servicio HTTP y persistencia local
class PersonajesService extends ChangeNotifier {
  final PersonajeService _apiService = PersonajeService();
  final FavoritesService _favService = FavoritesService();

  List<Personaje> _allPersonajes = [];
  List<Personaje> _personajes = [];
  List<Personaje> _favoritos = [];
  Set<String> _favoritoIds = {};

  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPaginas = 1;
  bool _hasNextPage = false;
  String _searchQuery = '';

  PersonajesService() {
    _init();
  }

  // Getters para el estado reactivo consumido en las pantallas
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPaginas => _totalPaginas;
  bool get hasNextPage => _hasNextPage;
  List<Personaje> get personajes => _personajes;
  List<Personaje> get favoritos => _favoritos;

  Future<void> _init() async {
    await loadFavoritos();
    await fetchPersonajes(page: 1);
  }

  /// Carga los personajes de una página remota
  Future<void> fetchPersonajes({int page = 1}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final resultado = await _apiService.getPersonajes(page: page);
      _currentPage = page;
      _totalPaginas = resultado.totalPaginas;
      _hasNextPage = resultado.tieneSiguiente;
      _allPersonajes = resultado.items;
      _applyFilter();
    } catch (e) {
      _errorMessage = 'No se pudo conectar con la API de Rick and Morty: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filtrado local en la página actual sin distinguir mayúsculas ni minúsculas
  void searchPersonajes(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      _personajes = List.from(_allPersonajes);
    } else {
      _personajes = _allPersonajes.where((p) {
        return p.name.toLowerCase().contains(query);
      }).toList();
    }
  }

  /// Navegación a la página siguiente
  void nextPage() {
    if (_hasNextPage && !_isLoading) {
      fetchPersonajes(page: _currentPage + 1);
    }
  }

  /// Navegación a la página anterior
  void previousPage() {
    if (_currentPage > 1 && !_isLoading) {
      fetchPersonajes(page: _currentPage - 1);
    }
  }

  /// Comprueba si un personaje está en favoritos
  bool isFavorito(int id) {
    return _favoritoIds.contains(id.toString());
  }

  /// Carga la lista de favoritos desde SharedPreferences y consulta sus datos
  Future<void> loadFavoritos() async {
    final ids = await _favService.getAllFavoriteIds();
    _favoritoIds = ids.toSet();

    if (ids.isNotEmpty) {
      try {
        final res = await _apiService.getPersonajesPorIds(ids, pageSize: ids.length);
        _favoritos = res.items;
      } catch (_) {
        // En caso de que no haya internet temporalmente, conserva los IDs
      }
    } else {
      _favoritos = [];
    }
    notifyListeners();
  }

  /// Alterna el estado de favorito para un personaje (persistencia y estado reactivo)
  Future<void> toggleFavorito(Personaje personaje) async {
    final strId = personaje.id.toString();
    final bool isFav = _favoritoIds.contains(strId);

    if (isFav) {
      _favoritoIds.remove(strId);
      _favoritos.removeWhere((p) => p.id == personaje.id);
    } else {
      _favoritoIds.add(strId);
      if (!_favoritos.any((p) => p.id == personaje.id)) {
        _favoritos.add(personaje);
      }
    }
    notifyListeners();

    await _favService.toggleFavorite(personaje.id);
  }
}
