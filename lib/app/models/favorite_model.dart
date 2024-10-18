// Generated by Dart Safe Data Class Generator. * Change this header on extension settings *
// ignore_for_file: type=lint
import 'dart:convert';


class FavoriteModel {
  final String id;
  const FavoriteModel({
    this.id = '',
  });

  FavoriteModel copyWith({
    String? id,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
     T cast<T>(String k) => map[k] is T ? map[k] as T : throw ArgumentError.value(map[k], k, '$T ← ${map[k].runtimeType}');
    return FavoriteModel(
      id: cast<String>('id'),
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteModel.fromJson(String source) => FavoriteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
   'FavoriteModel(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FavoriteModel &&
      other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
