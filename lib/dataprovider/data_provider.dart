import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';

//**Future Data Provider**
//**returns trainview list to rest of the app, trainview state for the app**
final trainviewsDataProvider = FutureProvider<List<TrainView>>((ref) async {
  //reading the trainviewsProvider that we made 
  //then getting the Train Views using its function
  return ref.watch(trainviewsServiceProvider).getTrainViews();
});

final filteredTrainViewsProvider = FutureProvider<List<TrainView>>((ref) async {
  final trainviews = await ref.watch(trainviewsDataProvider.future);
  final trainLineList = ref.watch(trainlineProvider);
  
  return trainviews.where((trainview) =>
      trainLineList.any((trainline) =>
        trainline.isSelected && trainview.line == trainline.line
      )
    ).toList();
});




final trainschedsDataProvider =
    FutureProvider<List<TrainSchedule>>((ref) async {
  //reading the trainviewsProvider that we made and then getting the Train Views using its function
  return ref.watch(trainviewsServiceProvider).getTrainScheds();
});

final searchProvider = StateProvider(((ref) => ' '));

//--------------------------------------------------------//
//**Selecting Data Provider*/
class TrainLine extends LinkedListEntry<TrainLine> {
  TrainLine({required this.line, required this.isSelected});

  final String line;
  bool isSelected;
}

var listOfTrainLines = [
  TrainLine(line: 'Airport', isSelected: false),
  TrainLine(line: 'Chestnut Hill East', isSelected: false),
  TrainLine(line: 'Chestnut Hill West', isSelected: false),
  TrainLine(line: 'Cynwyd', isSelected: false),
  TrainLine(line: 'Fox Chase', isSelected: false),
  TrainLine(line: 'Glenside', isSelected: false),
  TrainLine(line: 'Lansdale Doylestown', isSelected: false),
  TrainLine(line: 'Media Wawa', isSelected: false),
  TrainLine(line: 'Manayunk Norristown', isSelected: false),
  TrainLine(line: 'Paoli Thorndale', isSelected: false),
  TrainLine(line: 'Trenton', isSelected: false),
  TrainLine(line: 'Warminster', isSelected: false),
  TrainLine(line: 'Wilmington Newark', isSelected: false),
  TrainLine(line: 'West Trenton', isSelected: false),
];

enum TrainLineSelected { all, isSelected }

//watched
final trainlineSelectedProvider = StateProvider<TrainLineSelected>(
  //return default selected type, which is all are displayed
  (ref) => TrainLineSelected.all,
);

//used in main
final trainlineProvider = Provider<List<TrainLine>>((ref) {
  final selectedType = ref.watch(trainlineSelectedProvider);
  switch (selectedType) {
    case TrainLineSelected.all:
      return listOfTrainLines;
    case TrainLineSelected.isSelected:
      return listOfTrainLines.where((i) => (i.isSelected == true)).toList() +
          listOfTrainLines.where((i) => (i.isSelected == false)).toList();
  }
});

// final trainmodelsProvider = StateProvider<List<TrainView>>((ref) {
//   // Get the data from the server.
//   var data = await trainviewsDataProvider();
//   // Return the list of models.
//   return data;
// });



// // The StateNotifier class that will be passed to our StateNotifierProvider.
// // This class should not expose state outside of its "state" property, which means
// // no public getters/properties!
// // The public methods on this class will be what allow the UI to modify the state.
// class TrainViewsNotifier extends StateNotifier<List<TrainView>> {
//   // We initialize the list of trainviews to an empty list
//   TrainViewsNotifier(): super([]);

//   // Let's allow the UI to add trainviews.
//   void addTrainview(TrainView trainview) {
//     // Since our state is immutable, we are not allowed to do `state.add(todo)`.
//     // Instead, we should create a new list of todos which contains the previous
//     // items and the new one.
//     // Using Dart's spread operator here is helpful!
//     state = [...state, trainview];
//     // No need to call "notifyListeners" or anything similar. Calling "state ="
//     // will automatically rebuild the UI when necessary.
//   }

//   // Let's allow removing todos
//   void removeTrainview(String trainviewNo) {
//     // Again, our state is immutable. So we're making a new list instead of
//     // changing the existing list.
//     state = [
//       for (final trainview in state)
//         if (trainview.trainno != trainviewNo) trainview,
//     ];
//   }

  // Let's mark a todo as completed
  // void toggle(String trainviewNo) {
  //   state = [
  //     for (final trainview in state)
  //       // we're marking only the matching todo as completed
  //       if (trainview.hashCode == trainviewNo)
  //         // Once more, since our state is immutable, we need to make a copy
  //         // of the todo. We're using our `copyWith` method implemented before
  //         // to help with that.
  //         trainview.copyWith(completed: !trainview.line)
  //       else
  //         // other todos are not modified
  //         todo,
  //   ];
  // }
//}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
// final trainviewsProvider = StateNotifierProvider<TrainViewsNotifier, List<TrainView>>((ref) {
//   return TrainViewsNotifier();
// });


//var listOfTrainViewSelected = [];

// final filterProvider = StateProvider<String>((ref) => '');

// final filteredItemsProvider = Provider<List<TrainView>>((ref) {
//   final filter = ref.watch(filterProvider).state;
//   final items = ref.watch(trainviewsDataProvider).data?.value ?? [];

//   if (filter.isEmpty) {
//     return items;
//   }

//   return items.where((item) =>
//     item.name.toLowerCase().contains(filter.toLowerCase())
//   ).toList();
// });





// final viewProvider = StreamProvider.autoDispose<TrainView>((ref) async* {
//   final trainviewslist = ref.watch(trainviewsDataProvider);
//   trainviewslist.map(data: data, error: error, loading: loading)

// });

// final trainviewSelectedProvider = Provider<List<TrainView>>((ref) {
//   List<TrainView> results = [];

//   final views = ref.watch(trainviewsServiceProvider).getTrainViews();
//   Stream.fromFuture(views);

//   //return;
// });

// Future<List<TrainView>> whereAsync(Stream<TrainView> stream) async {
    
//     await for (var data in stream) {
//       bool valid = await myFilter(data);
//       if (valid) {
//         results.add(data);
//       }
//     }
//     return results;
//   }
