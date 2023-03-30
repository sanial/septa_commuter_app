import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';

//**Future Data Provider**
//returns trainview list to rest of the app, trainview state for the app
final trainviewsDataProvider = FutureProvider<List<TrainView>>((ref) async {
  //reading the trainviewsProvider that we made and then getting the Train Views using its function
  return ref.watch(trainviewsServiceProvider).getTrainViews();
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
var listOfTrainViewSelected = [];

enum TrainLineSelected { 
  all, 
  isSelected 
}

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
      return listOfTrainLines.where((i) => (i.isSelected == true)).toList() + listOfTrainLines.where((i) => (i.isSelected == false)).toList() ;
  }
});

//TODO watching the trainlineProvider to change trainviewProvider
// final trainviewProvider = Provider<List<TrainView>>((ref) { 
  

// final trainviewSelectedProvider = StateProvider<TrainLineSelected>(
//   final selectedViewType = ref.watch(trainlineSelectedProvider);
//   (ref) => TrainLineSelected.all,
  
// );





// class TrainlineNotifier extends StateNotifier<List<TrainLine>>{
//   TrainlineNotifier(): super([]);

//   void add(TrainLine trainline){
//     state = [...state, trainline];
//   }
//   void remove(String trainlineId){
//     state = [
//       for (final trainline in state)
//         if (trainline.line != todoId) todo,
//     ];
//   }
// }



// final trainlinesFilterProvider = StateNotifierProvider<TrainLineFilter, List<TrainLine>>(
//   // We return the default filter type, here name.
//   (ref) => TrainLineFilter.all,
// );

// final trainlinesProvider = Provider<List<TrainLine>>((ref) {
//   final trainlineFilterState = ref.watch(trainlinesFilterProvider).length;

//   switch(trainlineFilterState){
//     case TrainLineFilter.obtained:
//       return 
//   }
// });


