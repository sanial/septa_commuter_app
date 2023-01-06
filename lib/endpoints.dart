class Endpoints {
  // base url
  static String baseUrl = 'http://www3.septa.org/hackathon/$trainView/';
  static const String trainView = 'TrainView';

  static geturlendpoint(endpoint) {
    //TrainView
    if (endpoint == 'TrainView') {
      return baseUrl = 'http://www3.septa.org/hackathon/$endpoint/';
    } 
    //RRSchedules
    else if (endpoint == 'RRSchedules') {
      return baseUrl = 'http://www3.septa.org/hackathon/$endpoint/';
    }
  }
  geturlno(trainno){
    //RRScedules/trainno
    return baseUrl = 'http://www3.septa.org/hackathon/RRSchedules/$trainno';
  }

  // // receiveTimeout
  // static const int receiveTimeout = 15000;

  // // connectTimeout
  // static const int connectionTimeout = 30000;
}
