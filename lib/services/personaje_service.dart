import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/personaje.dart';
import '../models/resultado_paginado.dart';

class PersonajeService {
  /// Obtiene una página del catálogo general aprovechando la paginación remota de la API
  Future<ResultadoPaginado<Personaje>> getPersonajes({int page = 1}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/character?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> info = data['info'] as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;

      final personajes =
          results.map((json) => Personaje.fromJson(json)).toList();

      return ResultadoPaginado<Personaje>(
        items: personajes,
        totalPaginas: info['pages'] as int,
        tieneSiguiente: info['next'] != null,
      );
    } else {
      throw Exception('Failed to load characters: ${response.statusCode}');
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

    // 1. Cálculo de páginas totales
    final int totalPaginas = (allIds.length / pageSize).ceil();
    final bool tieneSiguiente = page < totalPaginas;

    // 2. Extracción de la sublista de IDs para la página actual
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

    // 3. Petición HTTP solo con los IDs de la página seleccionada
    final url = Uri.parse(ApiConfig.charactersByIds(pageIds));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
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
      throw Exception(
          'Failed to load favorite characters: ${response.statusCode}');
    }
  }
}