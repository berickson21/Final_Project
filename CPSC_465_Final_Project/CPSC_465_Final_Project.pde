int Window1_StartX; //<>// //<>// //<>//
int Window1_StartY;
int Window1_EndX;
int Window1_EndY;
int Window1_RangeX;
int Window1_RangeY;
float Window1_SteppingX;
int Window1_Scale_Start;
int Window1_Scale_End;

int Window2_StartX;
int Window2_StartY;
int Window2_EndX;
int Window2_EndY;
int Window2_Scale_Start;
int Window2_Scale_End;

int Window3_StartX;
int Window3_StartY;
int Window3_EndX;
int Window3_EndY;

int Window_Buffer = 15;
int Data_Buffer = 45;

float Window1_Width_Percent = .75;
float Window1_Height_Percent = .667;

String Y_Axis_Variable;

//int[] data;

int Bar_Buffer = 4; 

int Number_Days;

int Max_Steps;
int Min_Steps;
int Max_Sleep;
int Min_Sleep;
float Min_Rain;
float Max_Rain;
int Min_Max_Temp; //This mean Minimum value of the High temperature range.
int Max_Max_Temp;
int Min_Min_Temp;
int Max_Min_Temp;

Table data = new Table();
Day[] days;

float startX;
float startY;
float endX;
float endY;
boolean dragging;

int Num_Selected;
int Index_Offset;

void setup() {
  size(1600, 1000);
  surface.setResizable(true);

  loadTable();
  initValues();  
  //frameRate(5);

  Y_Axis_Variable = "Sleep";
  dragging = false;
}

void draw() {
  background(100);
  drawWindows();
  drawData();
  drawHighlight();
  drawZoom();
  drawDate();
}

void loadTable() {  

  data = loadTable("data.csv");
  Number_Days = data.getRowCount();

  days = new Day[Number_Days];
  for (int i = 0; i < Number_Days-1; i++) {
    days[i] = new Day(data.getString(i+1, 0), data.getInt(i+1, 1), data.getInt(i+1, 3), data.getFloat(i+1, 4), data.getInt(i+1, 6), data.getInt(i+1, 7) );
  }
}

void initValues() {
  Max_Steps     = getMaxInt(1);
  Min_Steps     = getMinInt(1);
  Max_Sleep     = getMaxInt(3);
  Min_Sleep     = getMinInt(3);
  Min_Rain      = getMinFloat(4);
  Max_Rain      = getMaxFloat(4);
  Min_Max_Temp  = getMinInt(6); //This mean Minimum value of the High temperature range.
  Max_Max_Temp  = getMaxInt(6);
  Min_Min_Temp  = getMinInt(7);
  Max_Min_Temp  = getMaxInt(7);
}

void drawWindows() {
  stroke(0, 0, 0);
  fill(255, 255, 255);
  Window1_StartX = Window_Buffer;
  Window1_StartY = Window_Buffer;
  Window1_EndX = int(width - (3 * Window_Buffer) - (width * (1 - Window1_Width_Percent)));
  Window1_EndY = int(height - (3 * Window_Buffer) - (height * (1 - Window1_Height_Percent)));
  rect(Window1_StartX, Window1_StartY, (Window1_EndX - Window1_StartX), (Window1_EndY - Window1_StartY));


  Window2_StartX = Window1_StartX;
  Window2_StartY = Window_Buffer + Window1_EndY;
  Window2_EndX = Window1_EndX;
  Window2_EndY = height - Window_Buffer;
  rect(Window2_StartX, Window2_StartY, (Window2_EndX - Window2_StartX), (Window2_EndY - Window2_StartY));

  Window3_StartX = Window1_EndX + Window_Buffer;
  Window3_StartY = Window_Buffer;
  Window3_EndX = width - Window_Buffer;
  Window3_EndY = height - Window_Buffer;  
  rect(Window3_StartX, Window3_StartY, (Window3_EndX - Window3_StartX), (Window3_EndY - Window3_StartY));
}

void drawData() {
  Window1_RangeX = Window1_EndX - Window1_StartX - 2*Data_Buffer;
  Window1_RangeY = Window1_EndY - (Window1_StartY + 2*Data_Buffer);
  Window1_SteppingX = float(Window1_RangeX) / Number_Days;



  //Draw Scale
  stroke(0, 0, 0);
  fill(0, 0, 0);
  beginShape(POINTS);

  for (int i = 0; i < Number_Days-1; i++) {
    vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - 5);
    strokeWeight(5);

    //Labels beginning of months
    if (i == 0 || days[i].get_date().equals("1/1/2016")) {
      vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - 5);
      text(days[i].get_month_name(), (i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - 10);
    } else if (days[i-1].get_month() < days[i].get_month()) {
      //println("month change");
      vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - 5);
      text(days[i].get_month_name(), (i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - 10);
    }

    strokeWeight(1);
  }

  endShape();
  strokeWeight(1);

  //Draw Temperature Max Data
  stroke(255, 0, 0);
  noFill();
  beginShape();
  for (int i = 0; i < Number_Days-1; i++) {
    vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - Data_Buffer - map(days[i].get_tmax(), Min_Min_Temp, Max_Max_Temp, 0, Window1_RangeY));
  }
  endShape();

  //Draw Temperature Min Data
  stroke(0, 0, 255);
  noFill();
  beginShape();
  for (int i = 0; i < Number_Days-1; i++) {
    vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - Data_Buffer - map(days[i].get_tmin(), Min_Min_Temp, Max_Max_Temp, 0, Window1_RangeY));
  }
  endShape();

  //Draw Rain Data
  stroke(117, 107, 177);
  //noFill();
  strokeWeight(5);
  beginShape(POINTS);
  for (int i = 0; i < Number_Days-1; i++) {

    vertex((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - Data_Buffer - map(days[i].get_rain(), Min_Rain, Max_Rain, 0, Window1_RangeY));
  }
  endShape();


  //Draw Sleep / Steps Data
  strokeWeight(1);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      stroke(50, 50, 255);
    } else {
  }
  line((i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - Data_Buffer, (i*Window1_SteppingX) + Window1_StartX + Data_Buffer, Window1_EndY - Data_Buffer - map(getYAxisValue(i), getYAxisMinValue(), getYAxisMaxValue(), 0, Window1_RangeY));
  stroke(0, 0, 0);
  }
}

void drawHighlight() {
  if (dragging) {
    endX = mouseX;
    select_points();
  }
}

void select_points()
{
  fill(127, 205, 187, 140);
  float x0 = min(endX, startX);
  float x1 = max(endX, startX);
  Num_Selected = 0;
  Index_Offset = 0;

  if (x0 < Window1_EndX - Data_Buffer && x0 > Window1_StartX + Data_Buffer) {
    rect(x0, Window1_EndY, x1 - x0, Window1_StartY - Window1_EndY );
  }

  for (int i = 0; i < Number_Days-1; i++) {
    if ((x0 < (i*Window1_SteppingX)+Window1_StartX+Data_Buffer) && (x1 > (i*Window1_SteppingX)+Window1_StartX+Data_Buffer)) {
      Num_Selected++;
      days[i].set_selected(true);
    } else {
      if (( x0 > (i*Window1_SteppingX)+Window1_StartX+Data_Buffer)) {
        Index_Offset++;
      }
      days[i].set_selected(false);
    }
  }
}

void drawZoom() {

  int Window2_RangeX = Window2_EndX - Window2_StartX - 2*Data_Buffer;
  int Window2_RangeY = Window2_EndY - (Window2_StartY+2*Data_Buffer);
  float Window2_SteppingX = float(Window2_RangeX) / Num_Selected;

  //Draw Scale
  stroke(0, 0, 0);
  fill(0, 0, 0);
  beginShape(POINTS);

  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      vertex(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - 5);

      strokeWeight(5);
      //Labels beginning of months
      if (i == 0 || days[i].get_date().equals("1/1/2016")) {
        vertex(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - 5);
        text(days[i].get_month_name(), ((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - 10);
      } else if (days[i].get_month() > days[i-1].get_month()) {
        //println("month change");
        vertex(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - 5);
        text(days[i].get_month_name(), ((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - 10);
      }
    }
    strokeWeight(1);
  }

  //Draw Temperature Max Data
  stroke(255, 0, 0);
  noFill();
  beginShape();
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      vertex(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - Data_Buffer - map(days[i].get_tmax(), Min_Min_Temp, Max_Max_Temp, 0, Window2_RangeY));
    }
  }
  endShape();

  //Draw Temperature Min Data
  stroke(0, 0, 255);
  noFill();
  beginShape();
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      vertex(((i-Index_Offset)*Window2_SteppingX)+Window1_StartX+Data_Buffer, Window2_EndY - Data_Buffer - map(days[i].get_tmin(), Min_Min_Temp, Max_Max_Temp, 0, Window2_RangeY));
    }
  }
  endShape();

  //Draw Rain Data
  stroke(117, 107, 177);
  //noFill();
  strokeWeight(5);
  beginShape(POINTS);
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      vertex(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - Data_Buffer - map(days[i].get_rain(), Min_Rain, Max_Rain, 0, Window2_RangeY));
    }
  }
  endShape();


  //Draw Sleep / Steps Data
  strokeWeight(1);
  fill(0, 0, 0);
  stroke(0, 0, 0);
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      line(((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY-Data_Buffer, ((i-Index_Offset)*Window2_SteppingX)+Window2_StartX+Data_Buffer, Window2_EndY - Data_Buffer - map(getYAxisValue(i), getYAxisMinValue(), getYAxisMaxValue(), 0, Window2_RangeY));
    }
  }
  //win3Data();
}

void win3Data() {
  fill(0, 0, 0);
  int line_num = 0;
  for (int i = 0; i < Number_Days-1; i++) {
    if (days[i].get_selected()) {
      text("hello", Window3_StartX +5, Window3_StartY + line_num*3);
      line_num +=5;
    } else {
    };
  }
}

void drawDate() {
  int i = get_index(mouseX);
  textAlign(CENTER);
  if (( mouseX > Window1_StartX + Data_Buffer) && (mouseX < Window1_EndX - Data_Buffer) && (mouseY > Window1_StartY) && (mouseY < Window1_EndY)) {
    text(days[i].get_date(), mouseX, Window1_EndY - 25);
  }
}

int get_index(float mouseX) {
  float index = (mouseX - Window1_StartX - Data_Buffer) / (Window1_EndX - Window1_StartX - 2*Data_Buffer) * Number_Days;
  int i = int(index);
  if (i >= Number_Days - 2)
    return Number_Days - 2;
  else if (i < 0)
    return 0;
  else
    return i;
}

void mousePressed() {
  dragging = true;
  startX = mouseX;
}

void mouseReleased() {
  dragging = false;
}


int getYAxisValue(int i) {
  if (Y_Axis_Variable == "Sleep") {
    return days[i].get_seconds_slept();
  } else {
    return days[i].get_steps();
  }
}

int getYAxisMinValue() {
  if (Y_Axis_Variable == "Sleep") {
    return Min_Sleep;
  } else {
    return Min_Steps;
  }
}

int getYAxisMaxValue() {
  if (Y_Axis_Variable == "Sleep") {
    return Max_Sleep;
  } else {
    return Max_Steps;
  }
}

void keyPressed() {
  if (keyCode == UP || keyCode == DOWN)
  {
    if (Y_Axis_Variable == "Sleep")
      Y_Axis_Variable = "Steps";
    else
      Y_Axis_Variable = "Sleep";
  }
}

int getMaxInt(int col_num) {
  int[] array = new int[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days-1; i++) {
    array[i] = data.getInt(i+1, col_num);
  }

  return max(array);
}

float getMaxFloat(int col_num) {
  float[] array = new float[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days-1; i++) {
    array[i] = data.getFloat(i+1, col_num);
  }

  return max(array);
}

int getMinInt(int col_num) {
  int[] array = new int[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days-1; i++) {
    array[i] = data.getInt(i+1, col_num);
  }

  return min(array);
}

float getMinFloat(int col_num) {
  float[] array = new float[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days-1; i++) {
    array[i] = data.getFloat(i+1, col_num);
  }

  return min(array);
}

/* 
 TODO:
 label axes with databuffer
 label window 3 if the data in the selected area is true it's sent to win 2.
 calculate:
 min
 max 
 avg
 tot steps 
 tot sleep
 start/end date
 have date follow mouse
 toggle keys
 
 For the Window 1 panel, this will be a bar graph of the temperature over time with a single point mark on each bar to indicate how many steps were walked, or something like that.
 The visual idiom is still being debated.
 
 The Window 2 panel will be the streched and enhanced version of the data selected from Window 1 with added details such as the weather that day, how much precipitation, etc.
 
 The window 3 panel will have the summary information from the Window 2 such as the average temperature during this time, the total number of steps, the number of days included in this
 selection, the begin date and end date, Standard deviation of the number of steps walked, avg precipitation over these days, etc.
 
 The window should be recizable and the data being shown should resize with the window as well. Including the text in the Window 3 panel.
 
 Should be able to sort data based on precipitation
 
 */