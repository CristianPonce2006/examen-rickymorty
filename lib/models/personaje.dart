class Personaje {
  final int id;
  final String name;
  final String status;
  final String image;
  final String species;
  final String gender;
  final String origin;
  final String location;

  Personaje({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
  });

  factory Personaje.fromJson(Map<String, dynamic> json) {
    return Personaje(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'Desconocido',
      image: json['image'] as String? ?? '',
      species: json['species'] as String? ?? 'Desconocido',
      gender: json['gender'] as String? ?? 'Desconocido',
      origin: (json['origin'] != null && json['origin']['name'] != null)
          ? json['origin']['name'] as String
          : 'Desconocido',
      location: (json['location'] != null && json['location']['name'] != null)
          ? json['location']['name'] as String
          : 'Desconocido',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'image': image,
      'species': species,
      'gender': gender,
      'origin': {'name': origin},
      'location': {'name': location},
    };
  }
}