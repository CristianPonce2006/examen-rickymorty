import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/personaje_service.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonajesService>(context);
    const primaryColor = Color(0xFF24282F);
    const accentColor = Color(0xFF97CE4C);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Personajes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: accentColor),
            tooltip: 'Mis Favoritos',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Recargar',
            onPressed: () => provider.fetchPersonajes(page: provider.currentPage),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en dimensión actual...',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: provider.searchPersonajes,
            ),
          ),
          // Aviso visual explícito de alcance de búsqueda local (RF-03)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Búsqueda local en la página actual (${provider.currentPage})',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: accentColor),
                  )
                : provider.errorMessage.isNotEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.wifi_off_rounded,
                                  size: 60,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Text(
                                'No se ha podido conectar a la API',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Posibles razones:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(
                                            'Tu dispositivo no tiene acceso a internet o Wi-Fi.',
                                            style: TextStyle(fontSize: 13, color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(
                                            'La señal de red es inestable o lenta.',
                                            style: TextStyle(fontSize: 13, color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(
                                            'Los servidores públicos de Rick and Morty están temporalmente fuera de servicio.',
                                            style: TextStyle(fontSize: 13, color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.refresh_rounded),
                                onPressed: () => provider.fetchPersonajes(
                                  page: provider.currentPage,
                                ),
                                label: const Text(
                                  'Reintentar',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : provider.personajes.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 56, color: Colors.grey),
                                  SizedBox(height: 12),
                                  Text(
                                    'No hay coincidencias en esta página.',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.personajes.length,
                            itemBuilder: (context, index) {
                              final personaje = provider.personajes[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      personaje.image,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                    ),
                                  ),
                                  title: Text(
                                    personaje.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${personaje.status} • ${personaje.species}',
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      provider.isFavorito(personaje.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: provider.isFavorito(personaje.id)
                                          ? accentColor
                                          : Colors.grey,
                                    ),
                                    onPressed: () => provider.toggleFavorito(personaje),
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(personaje: personaje),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: provider.currentPage > 1 && !provider.isLoading
                      ? provider.previousPage
                      : null,
                  icon: const Icon(Icons.arrow_back_ios, size: 16),
                  label: const Text('Anterior'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey,
                  ),
                ),
                Text(
                  'Pág ${provider.currentPage} de ${provider.totalPaginas}',
                  style: const TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: provider.hasNextPage && !provider.isLoading
                      ? provider.nextPage
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  label: const Text('Siguiente'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
