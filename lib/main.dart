// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:convert';
//import 'dart:html';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:septa_commuter_app/dataprovider/data_provider.dart';
import 'package:septa_commuter_app/models/train_schedule/train_schedule.dart';
import 'package:septa_commuter_app/models/train_view/train_view.dart';
import 'package:septa_commuter_app/services/services.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      title: 'Septa Commuter App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isStation = false;
  var _lines = ['Lansdale', 'Airport', 'Cynwyd'];
  var _trainlinefilters = [];

  @override
  Widget build(BuildContext context) {
    var filterTrainLines = buildItemsbyFilter(_isStation);
    final _selectedfilterchip = [];
    return Scaffold(
        appBar: AppBar(
          title: const Text('FetchTrainView'),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            //**TrainLine Filter */
            Consumer(builder: ((context, line, child) {
              final _trainlines = line.watch(trainlineProvider);

              return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Select Line: '),
                      ),
                      SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _trainlines.length,
                            itemBuilder: ((context, index) {
                              final trainline = _trainlines[index];
                              return FilterChip(
                                  backgroundColor: Colors.amber,
                                  label: Text(trainline.line),
                                  selected: trainline.isSelected,
                                  selectedColor: Colors.yellow,
                                  onSelected: ((bool selected) {
                                    setState(() {
                                      trainline.isSelected =
                                          !trainline.isSelected;
                                    });
                                    if (trainline.isSelected) {
                                      _trainlinefilters.add(trainline.line);
                                    } else {
                                      _trainlinefilters.remove(trainline.line);
                                      print(trainline.line);
                                    }
                                  }));
                            })),
                      ),
                    ],
                  ));
            })),
            SizedBox(height: 10,),
            //**TrainView Data */
            Consumer(builder: ((context, ref, child) {
              final _trainview_data = ref.watch(trainviewsDataProvider);

              //final _trainsched_data = ref.watch(trainschedsDataProvider);
              //final _search = ref.watch(searchProvider);
              return RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(trainviewsDataProvider.future);
                  await ref.read(trainviewsDataProvider);
                }, //TODO FIX not working
                child: _trainview_data.when(
                  data: (_trainview_data) {
                    //ListofTrainviewslive
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
                            // Consumer(builder: ((context, ref, child) {
                            //   List<TrainLineFilter> _trainlines =
                            //       ref.read(trainlineProvider);
                            // })),
                            // TextFormField(
                            //   onChanged: ((value) {
                            //     _search.state = value;
                            //   },),
                            // ),

                            SizedBox(
                              height: 500,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: trainviewList.length,
                                  itemBuilder: (context, index) {
                                    //Row of BorderLineBox stacks
                                    return Row(
                                      children: [
                                        Stack(
                                          alignment: AlignmentDirectional.topCenter,
                                          children: [
                                          
                                          //BorderLineBox
                                          Container(
                                            width: 135,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      20) //                 <--- border radius here
                                                  ),
                                            ),

                                            // decoration: ShapeDecoration(

                                            //   shape: RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.all(Radius.circular(5))
                                            //   )),
                                          ),
                                          // ClipRRect(
                                          //   borderRadius:
                                          //       BorderRadius.circular(30.0),
                                          //   child: Container(
                                          //     width: 20,
                                          //     height: 100,
                                          //     color: Colors.red,
                                          //   ),
                                          // ),
                                          //Concentric Circles
                                          Container(
                                                height: 20,
                                                width: 20,
                                                decoration: ShapeDecoration(
                                                  shape: CircleBorder(),
                                                  color: Colors.grey,
                                                  // other arguments
                                                ),
                                              ),
                                          //TrainLines Text
                                          Column(
                                            children: [
                                          
                                              SizedBox(height: 15,),
                                              Container( 
                                                margin: const EdgeInsets.all(3.0),
                                                padding: const EdgeInsets.all(3.0),
                                                decoration: trainlineBox(),
                                                child: Text(
                                                  trainviewList[index].line!,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color.fromARGB(255, 7, 103, 206),
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
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
                ),
              );
            })),
          ],
        ));
  }

  BoxDecoration trainlineBox() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color.fromARGB(255, 7, 103, 206), 
        width: 1.0,
        style: BorderStyle.solid,
        strokeAlign: StrokeAlign.center,
        ),
      borderRadius: BorderRadius.all(
          Radius.circular(30.0) //                 <--- border radius here
          ),
      
    );
  }

  List<String> buildItemsbyFilter(bool isStation) {
    if (isStation) {
      return _lines.where((station) {
        return station == 'Lansdale';
      }).map((station) {
        return "$station";
      }).toList();
    } else {
      return _lines.map((station) {
        return "$station";
      }).toList();
    }
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
