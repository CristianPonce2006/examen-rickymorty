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
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_off, size: 56, color: Colors.redAccent),
                              const SizedBox(height: 12),
                              Text(
                                provider.errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.black,
                                ),
                                icon: const Icon(Icons.refresh),
                                onPressed: () => provider.fetchPersonajes(
                                  page: provider.currentPage,
                                ),
                                label: const Text('Reintentar'),
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
