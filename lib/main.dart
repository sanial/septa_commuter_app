import 'dart:convert';
//import 'dart:html';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:septa_commuter_app/dataprovider/data_provider.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/models/train_view/train_view.dart';

//Fetch JSON document using http.get() method
// Future<List<TrainView>> fetchTrainViews(http.Client client) async {
//   final response =
//       await client.get(Uri.parse('http://www3.septa.org/hackathon/TrainView/'));

//   if (response.statusCode == 200) {
//     print('200 Works');
//   } else {
//     throw Exception('Failed to load album');
//   }

//   //Use the compute function to run parseTrainViews in a separate isolate
//   return compute(parseTrainViews, response.body);
// }

// //Funct that convertes a response body into a List<TrainView>
// List<TrainView> parseTrainViews(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<TrainView>((json) => TrainView.fromJson(json)).toList();
// }

void main() => runApp(ProviderScope(
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Septa Commuter App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final _trainview_data = ref.watch(trainviewsDataProvider);
    final _trainsched_data = ref.watch(trainschedsDataProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('FetchTrainView'),
        ),
        body: _trainview_data.when(
          data: (_trainview_data) {
            List<TrainView> trainviewList = _trainview_data
                .map(
                  (e) => e,
                )
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Headline', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: trainviewList.length,
                          itemBuilder: (context, index) {
                            return 
                                Chip(
                                  label: Text(trainviewList[index].line!),
                              
                            );
                          }),
            ),
                ],
              ));
        },
          error: (error, stackTrace) => Text(error.toString()),
          loading: (() => const Center(
                child: CircularProgressIndicator(),
              )),
        ));
  }
  //State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<TrainView>>(
//           future: fetchTrainViews(http.Client()),
//           builder: ((context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('$snapshot!.error');
//               // const Center(
//               //   child: Text("An error has occurred!"),
//               // );
//             } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//               // got data from snapshot but it is empty
//               return Text("no data");
//             } else if (snapshot.hasData) {
//               return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: ((context, index) {
//                     return Row(
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.all(10),
//                           color: Colors.amber[600],
//                           width: 5,
//                           height: 48,
//                         ),
//                         Chip(
//                           label: Text(snapshot.data![index].line!),
//                         ),
//                         Container(
//                           height: 50,
//                           color: Colors.white10,
//                           child: Text(snapshot.data![index].trainno!),
//                         ),
//                       ],
//                     );
//                     // ListTile(
//                     //   title: Text(snapshot.data![index].line),
//                     //   subtitle: Text(snapshot.data![index].dest),
//                     // );
//                   }));
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           })),
//     );
//   }
// }
