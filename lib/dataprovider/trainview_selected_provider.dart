// import 'dart:collection';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// import 'package:flutter/services.dart';
// import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
// import 'package:septa_commuter_app/services/services.dart';
// import '../models/train_view/train_view.dart';
// import 'package:uuid/uuid.dart';

// const _uuid = Uuid();
// /// A read-only description of a TrainViewSelected-item
// @immutable
// class TrainViewSelected<TrainView>{
//   const TrainViewSelected({
//     required this.description,
//     required this.id,
//     this.completed = false,
//   });

//   final String id;
//   final String description;
//   final bool completed;

//   @override
//   String toString() {
//     return 'TrainViewSelected(description: $description, completed: $completed)';
//   }
// }

// /// An object that controls a list of [TrainViewSelected].
// class TrainViewSelectedList extends StateNotifier<List<TrainViewSelected>> {
//   TrainViewSelectedList([List<TrainViewSelected>? initialTrainViewSelecteds]) : super(initialTrainViewSelecteds ?? []);

//   void add(String description) {
//     state = [
//       ...state,
//       TrainViewSelected(
//         id: _uuid.v4(),
//         description: description,
//       ),
//     ];
//   }

//   void toggle(String id) {
//     state = [
//       for (final TrainViewSelected in state)
//         if (TrainViewSelected.id == id)
//           TrainViewSelected(
//             id: TrainViewSelected.id,
//             completed: !TrainViewSelected.completed,
//             description: TrainViewSelected.description,
//           )
//         else
//           TrainViewSelected,
//     ];
//   }

//   void edit({required String id, required String description}) {
//     state = [
//       for (final TrainViewSelected in state)
//         if (TrainViewSelected.id == id)
//           TrainViewSelected(
//             id: TrainViewSelected.id,
//             completed: TrainViewSelected.completed,
//             description: description,
//           )
//         else
//           TrainViewSelected,
//     ];
//   }

//   void remove(TrainViewSelected target) {
//     state = state.where((TrainViewSelected) => TrainViewSelected.id != target.id).toList();
//   }
// }

// /// Some keys used for testing
// final addTrainViewSelectedKey = UniqueKey();
// final activeFilterKey = UniqueKey();
// final completedFilterKey = UniqueKey();
// final allFilterKey = UniqueKey();

// /// Creates a [TrainViewSelectedList] and initialise it with pre-defined values.
// ///
// /// We are using [StateNotifierProvider] here as a `List<TrainViewSelected>` is a complex
// /// object, with advanced business logic like how to edit a TrainViewSelected.
// final trainViewSelectedListProvider = StateNotifierProvider<TrainViewSelectedList, List<TrainViewSelected>>((ref) {
//   return TrainViewSelectedList(const [
//     TrainViewSelected(id: 'TrainViewSelected-0', description: 'hi'),
//     TrainViewSelected(id: 'TrainViewSelected-1', description: 'hello'),
//     TrainViewSelected(id: 'TrainViewSelected-2', description: 'bonjour'),
//   ]);
// });

// /// The different ways to filter the list of TrainViewSelecteds
// enum TrainViewSelectedListFilter {
//   all,
//   active,
//   completed,
// }

// /// The currently active filter.
// ///
// /// We use [StateProvider] here as there is no fancy logic behind manipulating
// /// the value since it's just enum.
// final trainViewSelectedListFilter = StateProvider((_) => TrainViewSelectedListFilter.all);

// /// The number of uncompleted TrainViewSelecteds
// ///
// /// By using [Provider], this value is cached, making it performant.\
// /// Even multiple widgets try to read the number of uncompleted TrainViewSelecteds,
// /// the value will be computed only once (until the TrainViewSelected-list changes).
// ///
// /// This will also optimise unneeded rebuilds if the TrainViewSelected-list changes, but the
// /// number of uncompleted TrainViewSelecteds doesn't (such as when editing a TrainViewSelected).
// final uncompletedTrainViewSelectedsCount = Provider<int>((ref) {
//   return ref.watch(trainViewSelectedListProvider).where((TrainViewSelected) => !TrainViewSelected.completed).length;
// });

// /// The list of TrainViewSelecteds after applying of [TrainViewSelectedListFilter].
// ///
// /// This too uses [Provider], to avoid recomputing the filtered list unless either
// /// the filter of or the TrainViewSelected-list updates.
// final filteredTrainViewSelecteds = Provider<List<TrainViewSelected>>((ref) {
//   final filter = ref.watch(trainViewSelectedListFilter);
//   final trainViewSelecteds = ref.watch(trainViewSelectedListProvider);

//   switch (filter) {
//     case TrainViewSelectedListFilter.completed:
//       return trainViewSelecteds.where((TrainViewSelected) => TrainViewSelected.completed).toList();
//     case TrainViewSelectedListFilter.active:
//       return trainViewSelecteds.where((TrainViewSelected) => !TrainViewSelected.completed).toList();
//     case TrainViewSelectedListFilter.all:
//       return trainViewSelecteds;
//   }
// });