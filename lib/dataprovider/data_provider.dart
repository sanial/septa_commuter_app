import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:septa_commuter_app/services/services.dart';
import '../models/train_view/train_view.dart';

final userDataProvider = FutureProvider<List<TrainView>>((ref) async {
  return ref.watch(userProvider).getUsers();
});
