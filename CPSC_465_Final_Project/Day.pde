 //<>//
class Day {

  String date;
  int steps;
  int sleep;
  float rain;
  int tmax;
  int tmin;
  boolean selected;


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

  void set_selected(boolean sel) {
    selected = sel;
  }
  boolean get_selected() {
    return selected;
  }
  //Uses the ASCII value of the month character to compare months.
  int get_month() { //<>// //<>// //<>//
    if (date.charAt(1) == '/') {
      return int(date.charAt(0));
    } else if (date.charAt(1) == '0') {
      return 58;
    } else if (date.charAt(1) == '1') {
      return 59;
    } else {
      return 60;
    }
  }
  //returns the name of the month. 
  String get_month_name() {
    switch (date.charAt(0)) {
    case '1':
      if (date.charAt(1) == '0')
        return "October";
      else if (date.charAt(1) == '1')
        return "November";
      else if (date.charAt(1) == '2')
        return "December";
      else 
      return "January";
    case '2':
      return "February";
    case '3':
      return "March";
    case '4':
      return "April";
    case '5':
      return "May";
    case '6':
      return "June";
    case '7':
      return "July";
    case '8':
      return "August";
    case '9':
      return "September";
    }
    return "the hell";
  }
}