import 'dart:async';

import 'package:easy_recipe/sqlite/models/Ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class IngredientDao {
  Future<Database> getDatabase() async {
    Database db = await openDatabase(
        join(await getDatabasesPath(), 'recipes.db'), onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE ingredients(id INTEGER PRIMARY KEY, name TEXT);");
    }, version: 1);

    return db;
  }

  Future<void> insertIngredient(Ingredient ingredient) async {
    final db = await getDatabase();

    await db.insert('ingredients', ingredient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteIngredient(Ingredient ingredient) async {
    final db = await getDatabase();
    await db.delete('ingredients', where: 'id = ? ', whereArgs: [ingredient.id]);
  }

  Future<List<Ingredient>> getIngredients() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> ingredients= await db.query('ingredients');
    return List.generate(ingredients.length, (index) {
        return Ingredient(
          id: ingredients[index]['id'],
          name: ingredients[index]['name']
        );
    });
  }
}
