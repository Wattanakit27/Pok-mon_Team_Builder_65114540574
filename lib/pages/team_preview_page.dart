import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';

class TeamPreviewPage extends StatelessWidget {
  const TeamPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Team')),
      body: Obx(() {
        if (c.selectedTeam.isEmpty) {
          return const Center(child: Text('ยังไม่ได้เลือกทีม'));
        }
        return ListView.builder(
          itemCount: c.selectedTeam.length,
          itemBuilder: (_, i) {
            final p = c.selectedTeam[i];
            return ListTile(
              leading: Image.network(p.imageUrl, width: 48, height: 48),
              title: Text(p.name[0].toUpperCase() + p.name.substring(1)),
            );
          },
        );
      }),
    );
  }
}
