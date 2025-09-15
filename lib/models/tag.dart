// tag.dart
class Tag {
  final String label;
  final String color; // hex string, es. "#FF0000"
  final String? note;

  Tag({required this.label, required this.color, this.note});

  Map<String, dynamic> toJson() => {
    'label': label,
    'color': color,
    'note': note,
  };

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(label: json['label'], color: json['color'], note: json['note']);
}
