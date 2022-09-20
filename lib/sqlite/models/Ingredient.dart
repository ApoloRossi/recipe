class Ingredient {

  final int? id;
  final String name;

  Ingredient({ this.id, required this.name });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name' : name
    };
  }
}