import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/personaje.dart';
import '../services/personaje_service.dart';

class DetailScreen extends StatelessWidget {
  final Personaje personaje;

  const DetailScreen({super.key, required this.personaje});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF24282F);
    const accentColor = Color(0xFF97CE4C);

    Color statusColor = Colors.grey;
    if (personaje.status.toLowerCase() == 'alive') {
      statusColor = accentColor;
    } else if (personaje.status.toLowerCase() == 'dead') {
      statusColor = Colors.redAccent;
    }

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 4),
                ),
                child: ClipOval(
                  child: Image.network(
                    personaje.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          personaje.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Consumer<PersonajesService>(
                        builder: (context, provider, child) {
                          final isFav = provider.isFavorito(personaje.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 30,
                            ),
                            color: isFav ? accentColor : Colors.grey,
                            onPressed: () => provider.toggleFavorito(personaje),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoTile(
                    Icons.monitor_heart,
                    'Estado',
                    personaje.status,
                    statusColor,
                  ),
                  _buildInfoTile(
                    Icons.pets,
                    'Especie',
                    personaje.species,
                    Colors.blueGrey,
                  ),
                  _buildInfoTile(
                    Icons.transgender,
                    'Género',
                    personaje.gender,
                    Colors.blueGrey,
                  ),
                  _buildInfoTile(
                    Icons.rocket_launch,
                    'Origen',
                    personaje.origin,
                    Colors.blueGrey,
                  ),
                  _buildInfoTile(
                    Icons.location_on,
                    'Ubicación actual',
                    personaje.location,
                    Colors.blueGrey,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF24282F),
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
