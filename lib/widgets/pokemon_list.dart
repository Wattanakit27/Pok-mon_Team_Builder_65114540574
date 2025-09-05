import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../models/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();

    return Obx(() {
      final List<Pokemon> list = c.filtered;
      if (list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GridView.builder(
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (ctx, i) {
            final p = list[i];
            final isSel = c.isSelected(p);
            return _PokemonCard(
              pokemon: p,
              selected: isSel,
              onTap: () {
                if (!isSel && c.selectedTeam.length >= 3) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('เลือกได้สูงสุด 3 ตัว'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 1400),
                    ),
                  );
                  return;
                }
                c.toggleMember(p); // << ใช้ method ที่มีจริง
              },
            );
          },
        ),
      );
    });
  }
}

class _PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool selected;
  final VoidCallback onTap;

  const _PokemonCard({
    required this.pokemon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.9),
            border: Border.all(
              color: selected ? const Color(0xFF7C4DFF) : Colors.grey.shade300,
              width: selected ? 1.6 : 1.0,
            ),
            boxShadow: const [
              BoxShadow(blurRadius: 10, offset: Offset(0, 4), color: Colors.black12),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Hero(
                  tag: 'pk-${pokemon.id}',
                  child: Image.network(pokemon.imageUrl, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    size: 18,
                    color: selected ? const Color(0xFF7C4DFF) : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
