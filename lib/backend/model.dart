abstract class Model {
  Map<String, dynamic> toJson();

  static Model fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
      'Model.fromJson() must be implemented by subclasses',
    );
  }
}
