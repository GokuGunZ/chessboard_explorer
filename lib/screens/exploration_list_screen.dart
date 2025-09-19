// exploration_list_screen.dart
import 'package:chessboard_explorer/models/user_graph_data.dart';
import 'package:chessboard_explorer/screens/exploration_screen.dart';
import 'package:chessboard_explorer/widgets/mini_chessboard.dart';
import 'package:flutter/material.dart';
import '../helper/local_storage_helper.dart';
import '../models/exploration.dart';

class ExplorationListScreen extends StatefulWidget {
  final UserGraphData userGraphData;

  const ExplorationListScreen({super.key, required this.userGraphData});

  @override
  State<ExplorationListScreen> createState() => _ExplorationListScreenState();
}

class _ExplorationListScreenState extends State<ExplorationListScreen> {
  List<Exploration> explorations = [];

  @override
  void initState() {
    super.initState();
    _loadExplorations();
  }

  Future<void> _loadExplorations() async {
    final data = await loadExplorations();
    setState(() {
      explorations = data;
    });
  }

  void _deleteExploration(String id) async {
    await deleteExploration(id);
    _loadExplorations();
  }

  Widget getLastConfigurationsChessboards(List<String> fenList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...fenList
            .sublist(0, fenList.length - 1)
            .map(
              (fen) => Row(
                children: [
                  MiniChessboard(fen: fen, size: 80),
                  Text("-->", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
        MiniChessboard(fen: fenList.last, size: 95),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista esplorazioni')),
      body: explorations.isEmpty
          ? const Center(child: Text("Nessuna esplorazione salvata"))
          : ListView.builder(
              itemCount: explorations.length,
              itemBuilder: (_, index) {
                final e = explorations[index];
                return ListTile(
                  subtitle: Text(e.name),
                  title: getLastConfigurationsChessboards(e.lastConfigurations),
                  leading: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteExploration(e.id),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExplorationScreen(
                        userGraphData: widget.userGraphData,
                        exploration: e,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
