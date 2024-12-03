class ModelsModel {
  final String? id;
  final int? created;
  final String? root;

  ModelsModel({
    this.id,
    this.created,
    this.root,
  });

  factory ModelsModel.fromJson(Map<String?, dynamic> json) {
    return ModelsModel(
      id: json['id'], // Allow null without default value
      created: json['created'], // Allow null
      root: json['root'], // Allow null
    );
  }

  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) {
      return ModelsModel.fromJson(data);
    }).toList();
  }
}
