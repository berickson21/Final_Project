
class Day {

String date;
int steps;
int sleep;
float rain;
int tmax;
int tmin;

  
  Day(String date_in, int steps_in, int sleep_in, float rain_in, int tmax_in, int tmin_in) {
  date = date_in;
  steps = steps_in;
  sleep = sleep_in;
  rain = rain_in;
  tmax = tmax_in;
  tmin = tmin_in;
  }



  String get_date() {return date;}
  int get_steps() {return steps;}
  int get_seconds_slept() {return sleep;}
  float get_rain() {return rain;}
  int get_tmax() {return tmax;}
  int get_tmin() {return tmin;}

}