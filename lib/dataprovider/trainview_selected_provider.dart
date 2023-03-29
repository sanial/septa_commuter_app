import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
/// A read-only description of a TrainViewSelected-item
@immutable
class TrainViewSelected<TrainView>{
  const TrainViewSelected({
    required this.description,
    required this.id,
    this.completed = false,
  });

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'TrainViewSelected(description: $description, completed: $completed)';
  }
}

/// An object that controls a list of [TrainViewSelected].
class TrainViewSelectedList extends StateNotifier<List<TrainViewSelected>> {
  TrainViewSelectedList([List<TrainViewSelected>? initialTrainViewSelecteds]) : super(initialTrainViewSelecteds ?? []);

  void add(String description) {
    state = [
      ...state,
      TrainViewSelected(
        id: _uuid.v4(),
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final TrainViewSelected in state)
        if (TrainViewSelected.id == id)
          TrainViewSelected(
            id: TrainViewSelected.id,
            completed: !TrainViewSelected.completed,
            description: TrainViewSelected.description,
          )
        else
          TrainViewSelected,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final TrainViewSelected in state)
        if (TrainViewSelected.id == id)
          TrainViewSelected(
            id: TrainViewSelected.id,
            completed: TrainViewSelected.completed,
            description: description,
          )
        else
          TrainViewSelected,
    ];
  }

  void remove(TrainViewSelected target) {
    state = state.where((TrainViewSelected) => TrainViewSelected.id != target.id).toList();
  }
}