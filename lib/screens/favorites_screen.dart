import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/personaje_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PersonajesService>(context);
    const primaryColor = Color(0xFF24282F);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mis Favoritos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: provider.favoritos.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aún no hay personajes en tu universo.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.favoritos.length,
              itemBuilder: (context, index) {
                final personaje = provider.favoritos[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(personaje.image),
                      backgroundColor: primaryColor,
                    ),
                    title: Text(
                      personaje.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(personaje.origin),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => provider.toggleFavorito(personaje),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
