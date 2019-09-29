import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SprefUtil {

  static void storeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      if (spref.getStringList('favs').isEmpty) {
        List<String> currentFavs = [];
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      } else {
        List<String> currentFavs = spref.getStringList('favs');
        currentFavs.add(id);
        spref.setStringList('favs', currentFavs);
      }
    });
  }

  static void removeFavorite(String id) {
    SharedPreferences.getInstance().then((spref) {
      List<String> currentFavs = spref.getStringList('favs');
      currentFavs.removeWhere((sprefId) => sprefId == id);
      spref.setStringList('favs', currentFavs);
    });
  }

}
