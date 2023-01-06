class TrainLineFilter {
  final String id;
  final String name;
  final bool isSelected;

  const TrainLineFilter(
      {required this.id,
      required this.name,
      required this.isSelected});

  TrainLineFilter copy({String? id, String? name, String? title, bool? isSelected}) =>
      TrainLineFilter(
          id: id ?? this.id,
          name: name ?? this.name,
          isSelected: isSelected ?? this.isSelected);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainLineFilter &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          isSelected == other.isSelected;

  @override
  int get hashCode => name.hashCode  ^ isSelected.hashCode;
}