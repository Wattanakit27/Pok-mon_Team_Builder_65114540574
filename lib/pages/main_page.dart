import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../widgets/pokemon_list.dart';
import 'team_preview_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();
    final nameCtrl = TextEditingController(text: c.teamName.value);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 12,
        title: Obx(() => Text('${c.teamName.value} (${c.selectedTeam.length}/3)')),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'ดูทีมที่เลือก',
            icon: const Icon(Icons.group),
            onPressed: () => Get.to(() => const TeamPreviewPage()),
          ),
          const SizedBox(width: 4),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              onChanged: c.setQuery,
              decoration: InputDecoration(
                hintText: 'Search Pokémon...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 1.6),
                ),
              ),
            ),
          ),
          const Expanded(child: PokemonList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.menu),
        label: const Text('Actions'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Rename Team'),
                      onTap: () async {
                        Navigator.pop(ctx);
                        nameCtrl.text = c.teamName.value;
                        final newName = await showDialog<String>(
                          context: context,
                          builder: (dCtx) => AlertDialog(
                            title: const Text('Rename Team'),
                            content: TextField(
                              controller: nameCtrl,
                              decoration: const InputDecoration(hintText: 'Team name'),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(dCtx, nameCtrl.text.trim()),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                        if (newName != null && newName.isNotEmpty) {
                          c.renameTeam(newName);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.refresh),
                      title: const Text('Reset Team'),
                      onTap: () {
                        Navigator.pop(ctx);
                        c.resetTeam();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ล้างทีมแล้ว'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 1200),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
