// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names

import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
//import 'dart:html';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:septa_commuter_app/dataprovider/data_provider.dart';
import 'package:septa_commuter_app/dataprovider/trainview_selected_provider.dart';
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
  List filteredTrainview = [];
  //var _trainlinefilters = [];

  // @override
  // void initState() {
  //   super.initState();

  //   // Get the list of cars from the future provider.
  //   trainviewsDataProvider.listen(() {
  //     setState(() {
  //       this.cars = cars;
  //       this.filteredCars = cars.where((car) => car.name.contains('1')).toList();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var filterTrainLines = buildItemsbyFilter(_isStation);
    final List<String> _trainlinefiltered = <String>[];
    final _selectedfilterchip = [];

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 45,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'SEPTA Regional Rail',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: backgroundColor,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        drawer: Drawer(
            child: Column(children: [
          //**TrainLine Filter**/
          Consumer(builder: ((context, line, child) {
            final _trainlines = line.watch(trainlineProvider);

            //Horizontal trainline FilterChip scroll
            return Column(
              children: [
                //Trainlines Scroll
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('I AM TAKING RAIL LINE: '),
                        ),
                        //Trainlines List
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _trainlines.length,
                              itemBuilder: ((context, index) {
                                //Each trainline
                                final trainline = _trainlines[index];
                                //     _trainlines_queue.elementAt(index);
                                return Column(
                                  children: [
                                    FilterChip(
                                        side: BorderSide(
                                            color: trainlineBoxColor,
                                            strokeAlign: StrokeAlign.center),
                                        padding: EdgeInsets.all(8),
                                        backgroundColor: trainlineBoxColor,
                                        label: Text(
                                          trainline.line,
                                          style: TextStyle(
                                              color: trainline.isSelected
                                                  ? trainlineBoxColor
                                                  : Colors.white),
                                        ),
                                        selected: trainline.isSelected,
                                        selectedColor: Colors.white,
                                        //Color.fromARGB(255, 67, 66, 66), really pretty darkgrey
                                        checkmarkColor: trainlineBoxColor,
                                        onSelected: ((bool selected) {
                                          setState(() {
                                            trainline.isSelected =
                                                !trainline.isSelected;
                                            line.refresh(trainlineProvider);

                                            //if trainline filterchips selected
                                            //check if an empty list contains it, and add it to list
                                            //else if trainline filterchip unselected, remove from list
                                            if (selected) {
                                              line.watch(
                                                  trainlineSelectedProvider);
                                              line
                                                      .read(
                                                          trainlineSelectedProvider
                                                              .notifier)
                                                      .state =
                                                  TrainLineSelected.isSelected;

                                              filteredTrainview
                                                  .add(trainline.line);
                                              print(filteredTrainview);
                                            }
                                            if (!selected) {
                                              filteredTrainview
                                                  .remove(trainline.line);
                                            }
                                          });
                                        })),
                                  ],
                                );
                              })),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
              ],
            );
          })),
        ])),
        bottomNavigationBar: SizedBox(
          height: 55,
          child: BottomAppBar(
            color: Colors.white,
            elevation: 0,
            child: Icon(
              Icons.home_outlined,
              color: borderLineBox,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              //**TrainView Data */
              Consumer(builder: ((context, ref, child) {
                //final _trainview_data = ref.watch(trainviewsDataProvider);
                final _trainview_data = ref.watch(filteredTrainViewsProvider);
                //final _trainview_filtered_data = ref.watch(filteredTrainViewsProvider);
                //final _search = ref.watch(searchProvider);
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(trainviewsDataProvider.future);
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
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 550,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: trainviewList.length,
                                    //filteredTrainview.isNotEmpty? trainviewList.where((i) => filteredTrainview.contains(i.line)).length: trainviewList.length,
                                    //isEmpty? if true display only selected trains : else if false display all
                                    // trainline.isSelected
                                    //               ? trainlineBoxColor
                                    //               : Colors.white
                                    // trainviewList.length,
                                    itemBuilder: (context, index) {
                                      // if (trainviewList.contains(element)) {

                                      // }
                                      //Row of BorderLineBox stacks
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Column(
                                            children: [
                                              //Nested Stacks
                                              Stack(
                                                // alignment: Alignment.bottomCenter,
                                                clipBehavior: Clip.none,
                                                children: [
                                                  //Concentric Circles
                                                  // Positioned(
                                                  //   top: 0,
                                                  //   left: 55,
                                                  //   height: 20,
                                                  //   width: 20,
                                                  //   child: Container(
                                                  //     height: 20,
                                                  //     width: 20,
                                                  //     decoration:
                                                  //         ShapeDecoration(
                                                  //       shape: CircleBorder(),
                                                  //       color: borderLineBox,
                                                  //     ),
                                                  //   ),
                                                  // ),

                                                  //BorderLineBox stacks
                                                  Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .topCenter,
                                                      children: [
                                                        //BorderLineBox
                                                        Container(
                                                          width: 132,
                                                          height: 459,
                                                          decoration:
                                                              BoxDecoration(
                                                            // color:
                                                            //     borderLineBox,
                                                            border: Border.all(
                                                                color:
                                                                    borderLineBox,
                                                                width: 0.73),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30) //                 <--- border radius here
                                                                    ),
                                                          ),
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

                                                        //TrainLine Text
                                                        Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 25,
                                                            ),

                                                            //Trainlinefilter box
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              decoration:
                                                                  trainlineBox(),
                                                              child: Text(
                                                                trainviewList[
                                                                        index]
                                                                    .line!,
                                                                //filteredTrainview.isNotEmpty? if(filteredTrainview.contains(trainviewList[index].line!))){Text(trainviewList[index].line!)}: Text(trainviewList[index].line!),

                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        trainlineBoxColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                  trainviewList[
                                                                          index]
                                                                      .trainno!),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                  trainviewList[
                                                                          index]
                                                                      .currentstop!),
                                                            ),
                                                            Container(
                                                              child: Text('${
                                                                  trainviewList[
                                                                          index]
                                                                      .late!}'),
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                            ],
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
          ),
        ));
  }

  static const trainlineBoxColor = Color(0xFF3E68FF);
  static const backgroundColor = Color(0xFFF1F1F1);
  static const borderLineBox = Color.fromARGB(255, 116, 115, 115);

  BoxDecoration trainlineBox() {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        color: trainlineBoxColor,
        width: 1,
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
