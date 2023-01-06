import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';

//returns trainview list to rest of the app, trainview state for the app
final trainviewsDataProvider = FutureProvider<List<TrainView>>((ref) async {
  //reading the trainviewsProvider that we made and then getting the Train Views using its function
  return ref.watch(trainviewsProvider).getTrainViews();
});

final trainschedsDataProvider = FutureProvider<List<TrainSchedule>>((ref) async {
  //reading the trainviewsProvider that we made and then getting the Train Views using its function
  return ref.watch(trainviewsProvider).getTrainScheds();
});