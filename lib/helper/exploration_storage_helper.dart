// exploration_storage_helper.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/exploration.dart';

class ExplorationStorageHelper {
  static const String boxName = 'explorations';

  /// Apre la box Hive per le esplorazioni
  static Future<Box<Exploration>> _openBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      // Assicurati di registrare l'adapter di Exploration prima
      // Hive.registerAdapter(ExplorationAdapter());
    }
    return await Hive.openBox<Exploration>(boxName);
  }

  /// Restituisce tutte le esplorazioni salvate
  static Future<List<Exploration>> getAllExplorations() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Salva una nuova esplorazione o aggiorna una esistente (usando id)
  static Future<void> saveExploration(Exploration exploration) async {
    final box = await _openBox();
    await box.put(exploration.id, exploration);
  }

  /// Cancella un'esplorazione tramite id
  static Future<void> deleteExploration(String explorationId) async {
    final box = await _openBox();
    await box.delete(explorationId);
  }

  /// Recupera una specifica esplorazione tramite id
  static Future<Exploration?> getExplorationById(String explorationId) async {
    final box = await _openBox();
    return box.get(explorationId);
  }

  /// Aggiorna un'esplorazione esistente (utile per aggiornare grafo o mosse)
  static Future<void> updateExploration(Exploration exploration) async {
    final box = await _openBox();
    if (box.containsKey(exploration.id)) {
      await box.put(exploration.id, exploration);
    }
  }

  /// Genera un nuovo id unico per una nuova esplorazione
  static String generateNewId() =>
      DateTime.now().millisecondsSinceEpoch.toString();
}
