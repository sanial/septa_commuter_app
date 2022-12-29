import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';

final trainviewsDataProvider = FutureProvider<List<TrainView>>((ref) async {
  return ref.watch(trainviewsProvider).getTrainViews();
});

// final trainschedDataProvider = FutureProvider<List<TrainSchedule>>(((ref) async {
//   return ref.watch(trainschedProvider).getTrainSchedule();
// });
