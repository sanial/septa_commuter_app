import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../models/train_view/train_view.dart';

class ApiServices {
  String endpoint = 'http://www3.septa.org/hackathon/TrainView/';
  Future <List<TrainView>> getUsers() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map((json) => TrainView.fromJson(json)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userProvider = Provider<ApiServices>((ref)=> ApiServices());
