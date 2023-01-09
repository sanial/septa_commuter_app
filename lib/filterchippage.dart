// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilterChipPage extends StatefulWidget {
  FilterChipPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FilterChipPageState createState() => _FilterChipPageState();
}

class _FilterChipPageState extends State<FilterChipPage> {
  var _isLonger3Cm = false;
  var _items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    var filterItems = buildItemsByFilter(_isLonger3Cm);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              FilterChip(
                selected: _isLonger3Cm,
                selectedColor: Colors.yellow,
                label: Text(
                  "Longer 3cm",
                  style: TextStyle(color: Colors.white),
                ),
                shape: StadiumBorder(),
                backgroundColor: Colors.pink,
                onSelected: (selected) {
                  setState(() {
                    _isLonger3Cm = selected;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filterItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(filterItems[index])),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
                color: Colors.black45,
              );
            },
          ),
        )
      ],
    );
  }

  List<String> buildItemsByFilter(bool isLonger3Cm) {
    if (isLonger3Cm) {
      return _items.where((item) {
        return item > 3;
      }).map((item) {
        return "$item cm";
      }).toList();
    } else {
      return _items.map((item) {
        return "$item cm";
      }).toList();
    }
  }
}