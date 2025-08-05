import 'dart:convert';

import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/models/startup_idea.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Save startup ideas
  Future<bool> saveIdeas(List<StartupIdea> ideas) async {
    try {
      final List<Map<String, dynamic>> ideasJson =
          ideas.map((idea) => idea.toJson()).toList();
      return await _preferences!.setString(
        AppConstants.ideasKey,
        jsonEncode(ideasJson),
      );
    } catch (e) {
      return false;
    }
  }

  // Get startup ideas
  Future<List<StartupIdea>> getIdeas() async {
    try {
      final String? ideasString = _preferences!.getString(
        AppConstants.ideasKey,
      );
      if (ideasString == null) return [];

      final List<dynamic> ideasJson = jsonDecode(ideasString);
      return ideasJson.map((json) => StartupIdea.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save voted ideas (to prevent multiple votes)
  Future<bool> saveVotedIdeas(Set<String> votedIds) async {
    try {
      return await _preferences!.setStringList(
        AppConstants.votedIdeasKey,
        votedIds.toList(),
      );
    } catch (e) {
      return false;
    }
  }

  // Get voted ideas
  Future<Set<String>> getVotedIdeas() async {
    try {
      final List<String>? votedIds = _preferences!.getStringList(
        AppConstants.votedIdeasKey,
      );
      return votedIds?.toSet() ?? <String>{};
    } catch (e) {
      return <String>{};
    }
  }

  // Save dark mode preference
  Future<bool> saveDarkMode(bool isDarkMode) async {
    try {
      return await _preferences!.setBool(AppConstants.darkModeKey, isDarkMode);
    } catch (e) {
      return false;
    }
  }

  // Get dark mode preference
  bool isDarkMode() {
    return _preferences!.getBool(AppConstants.darkModeKey) ?? false;
  }

  // Clear all data
  Future<bool> clearAllData() async {
    try {
      return await _preferences!.clear();
    } catch (e) {
      return false;
    }
  }
}
