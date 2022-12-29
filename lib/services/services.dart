import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';

import '../models/train_view/train_view.dart';

class TrainViewApiService {
  String endpoint = 'http://www3.septa.org/hackathon/TrainView/';
  Future<List<TrainView>> getTrainViews() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((json) => TrainView.fromJson(json)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  
}
// class TrainSchedApiService{
//   String schedulepoint = 'https://www3.septa.org/hackathon/RRSchedules/401';
//   String trainno = '401';
//   Future <List<TrainSchedule>> getTrainSchedule() async{
//     Response response = await get(Uri.parse(schedulepoint));
//     if (response.statusCode == 200) {
//       final List result = jsonDecode(response.body);
//       return result.map((json) => TrainSchedule.fromJson(json)).toList();
//     } else {
//       throw Exception(response.reasonPhrase);
//   }
// }

final trainviewsProvider = Provider<TrainViewApiService>((ref) => TrainViewApiService());
//final trainschedProvider = Provider<TrainSchedApiService>((ref) => TrainSchedApiService());