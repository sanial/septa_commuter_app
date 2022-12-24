//TrainView class that contains data
//includes fromJson() factory method to make it easy to
//create a TrainView starting with a JSON object

class TrainView {
  String? lat;
  String? lon;
  String? trainno;
  String? service;
  String? dest;
  String? currentstop;
  String? nextstop;
  String? line;
  String? consist;
  double? heading;
  int? late;
  String? source;
  String? track;
  String? trackChange;

  TrainView({
    this.lat,
    this.lon,
    this.trainno,
    this.service,
    this.dest,
    this.currentstop,
    this.nextstop,
    this.line,
    this.consist,
    this.heading,
    this.late,
    this.source,
    this.track,
    this.trackChange,
  });

  factory TrainView.fromJson(Map<String, dynamic> json) => TrainView(
        lat: json['lat'] as String?,
        lon: json['lon'] as String?,
        trainno: json['trainno'] as String?,
        service: json['service'] as String?,
        dest: json['dest'] as String?,
        currentstop: json['currentstop'] as String?,
        nextstop: json['nextstop'] as String?,
        line: json['line'] as String?,
        consist: json['consist'] as String?,
        heading: (json['heading'] as num?)?.toDouble(),
        late: json['late'] as int?,
        source: json['SOURCE'] as String?,
        track: json['TRACK'] as String?,
        trackChange: json['TRACK_CHANGE'] as String?,
      );

  // Map<String, dynamic> toJson() => {
  //       'lat': lat,
  //       'lon': lon,
  //       'trainno': trainno,
  //       'service': service,
  //       'dest': dest,
  //       'currentstop': currentstop,
  //       'nextstop': nextstop,
  //       'line': line,
  //       'consist': consist,
  //       'heading': heading,
  //       'late': late,
  //       'SOURCE': source,
  //       'TRACK': track,
  //       'TRACK_CHANGE': trackChange,
  //     };
}
