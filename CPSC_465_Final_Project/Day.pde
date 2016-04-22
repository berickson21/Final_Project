

float rain;
int temp;
int steps;
float hours_slept;

void Day(int ti, int si, float hi, float ri){
    rain = ri;
    temp = ti;
    steps = si;
    hours_slept = hi;
}

float get_rain(){return rain;}
float get_hours_slept(){return hours_slept;}
int get_steps(){return steps;}
int get_temp(){return temp;}