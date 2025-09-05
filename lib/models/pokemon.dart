class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  factory Pokemon.fromApiJson(Map<String, dynamic> json) {
    // json['url'] is like .../pokemon/25/
    final url = json['url'] as String;
    final parts = url.split('/').where((e) => e.isNotEmpty).toList();
    final id = int.tryParse(parts.last) ?? 0;
    return Pokemon(
      id: id,
      name: json['name'] as String,
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'imageUrl': imageUrl};

  factory Pokemon.fromMap(Map<String, dynamic> m) => Pokemon(
        id: m['id'] as int,
        name: m['name'] as String,
        imageUrl: m['imageUrl'] as String,
      );
}
