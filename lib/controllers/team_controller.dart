import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class TeamController extends GetxController {
  // ---- state ----
  final allPokemon = <Pokemon>[].obs;
  final selectedTeam = <Pokemon>[].obs; // ใช้ชื่อนี้เสมอ
  final teamName = 'My Team'.obs;
  final query = ''.obs;

  // ---- persistence ----
  final _box = GetStorage();
  static const _kTeamKey = 'team_members';
  static const _kNameKey = 'team_name';

  @override
  void onInit() {
    super.onInit();
    _loadPersisted();
    loadInitial();
  }

  Future<void> loadInitial() async {
    try {
      final list = await ApiService.fetchFirstN(40); // >=20
      allPokemon.assignAll(list);
    } catch (_) {
      // ถ้าอยากมี fallback seed ใส่ตรงนี้ได้
    }
  }

  // ---- search ----
  void setQuery(String q) => query.value = q;
  List<Pokemon> get filtered {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return allPokemon;
    return allPokemon
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  // ---- team ops ----
  bool isSelected(Pokemon p) =>
      selectedTeam.any((e) => e.id == p.id);

  void toggleMember(Pokemon p) {
    if (isSelected(p)) {
      selectedTeam.removeWhere((e) => e.id == p.id);
    } else {
      if (selectedTeam.length >= 3) return;
      selectedTeam.add(p);
    }
    _persist();
  }

  void renameTeam(String name) {
    teamName.value = name.trim().isEmpty ? 'My Team' : name.trim();
    _persist();
  }

  void resetTeam() {
    selectedTeam.clear();
    teamName.value = 'My Team';
    _persist();
  }

  // ---- persist helpers ----
  void _persist() {
    _box.write(_kTeamKey, selectedTeam.map((e) => e.toMap()).toList());
    _box.write(_kNameKey, teamName.value);
  }

  void _loadPersisted() {
    final name = _box.read<String>(_kNameKey);
    if (name != null) teamName.value = name;

    final raw = _box.read<List<dynamic>>(_kTeamKey);
    if (raw != null) {
      selectedTeam.assignAll(
        raw.map((e) => Pokemon.fromMap(Map<String, dynamic>.from(e))),
      );
    }
  }
}
