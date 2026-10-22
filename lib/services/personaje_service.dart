import 'package:flutter/material.dart';
import '../models/personaje.dart';
import '../core/api_config.dart';

class PersonajesService extends ChangeNotifier {
  List<Personaje> _personajes = [];
  List<Personaje> _personajesFiltrados = [];
  List<Personaje> _favoritos = [];

  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasNextPage = true;
  String _searchQuery = '';

  List<Personaje> get personajes =>
      _searchQuery.isEmpty ? _personajes : _personajesFiltrados;
  List<Personaje> get favoritos => _favoritos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;

  PersonajesService() {
    fetchPersonajes();
  }

  Future<void> fetchPersonajes({int page = 1}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _currentPage = page;
    } catch (e) {
      _errorMessage = 'Falla espacial en la conexión. Intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPersonajes(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _personajesFiltrados = _personajes;
    } else {
      _personajesFiltrados = _personajes
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void toggleFavorito(Personaje personaje) {
    final isFav = _favoritos.any((p) => p.id == personaje.id);
    if (isFav) {
      _favoritos.removeWhere((p) => p.id == personaje.id);
    } else {
      _favoritos.add(personaje);
    }

    notifyListeners();
  }

  bool isFavorito(int id) => _favoritos.any((p) => p.id == id);

  void nextPage() {
    if (_hasNextPage) fetchPersonajes(page: _currentPage + 1);
  }

  void previousPage() {
    if (_currentPage > 1) fetchPersonajes(page: _currentPage - 1);
  }
}
