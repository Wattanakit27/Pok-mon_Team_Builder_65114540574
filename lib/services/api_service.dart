import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static Future<List<Pokemon>> fetchFirstN(int n) async {
    final res = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$n'));
    if (res.statusCode != 200) {
      throw Exception('PokeAPI error ${res.statusCode}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List).cast<Map<String, dynamic>>();
    return results.map((e) => Pokemon.fromApiJson(e)).toList();
  }
}
