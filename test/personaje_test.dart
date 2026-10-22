import 'package:flutter_test/flutter_test.dart';
import 'package:examen_rickymorty/models/personaje.dart';

void main() {
  group('Pruebas unitarias de Examen Rick and Morty', () {
    test('Personaje.fromJson procesa correctamente datos y anidados', () {
      final json = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'gender': 'Male',
        'origin': {'name': 'Earth (C-137)'},
        'location': {'name': 'Citadel of Ricks'},
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      };

      final personaje = Personaje.fromJson(json);

      expect(personaje.id, 1);
      expect(personaje.name, 'Rick Sanchez');
      expect(personaje.status, 'Alive');
      expect(personaje.species, 'Human');
      expect(personaje.gender, 'Male');
      expect(personaje.origin, 'Earth (C-137)');
      expect(personaje.location, 'Citadel of Ricks');
    });
  });
}
