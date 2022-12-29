class TrainSchedule {
  String? station;
  String? schedTm;
  String? estTm;
  String? actTm;

  TrainSchedule({this.station, this.schedTm, this.estTm, this.actTm});

  factory TrainSchedule.fromJson(Map<String, dynamic> json) => TrainSchedule(
        station: json['station'] as String?,
        schedTm: json['sched_tm'] as String?,
        estTm: json['est_tm'] as String?,
        actTm: json['act_tm'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'station': station,
        'sched_tm': schedTm,
        'est_tm': estTm,
        'act_tm': actTm,
      };
}
