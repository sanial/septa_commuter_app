import 'dart:convert';
import 'package:septa_commuter_app/endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';

import '../models/train_view/train_view.dart';

//provides the TrainViewApi Service with all its functions to the rest of you code
final trainviewsProvider = Provider<TrainViewApiService>((ref) => TrainViewApiService());

class TrainViewApiService {
  // static const String baseUrl = 'http://www3.septa.org/hackathon/$trainView/';
  // static const String trainView = 'TrainView';
  
  static String trainViewType = '';
  var p = 2;

  Future<List<TrainView>> getTrainViews() async {
    Response response = await get(Uri.parse(Endpoints.baseUrl));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((json) => TrainView.fromJson(json)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<TrainSchedule>> getTrainScheds() async {
    Response response = await get(Uri.parse(Endpoints.geturlendpoint('RRSchedules')));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((json) => TrainSchedule.fromJson(json)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  // if(p == 1){

  // }
}


