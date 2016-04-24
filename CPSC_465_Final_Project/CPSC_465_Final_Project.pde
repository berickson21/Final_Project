int Window1_StartX;
int Window1_StartY;
int Window1_EndX;
int Window1_EndY;

int Window2_StartX;
int Window2_StartY;
int Window2_EndX;
int Window2_EndY;

int Window3_StartX;
int Window3_StartY;
int Window3_EndX;
int Window3_EndY;

int Window_Buffer = 15;
int Data_Buffer = 15;

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

void setup() {
  size(1600, 1000);
  surface.setResizable(true);

  loadTable();
  initValues();  
  frameRate(5);

  Y_Axis_Variable = "Sleep";
}

void draw() {
  background(100);

  drawWindows();
  drawData();
}

void loadTable() {  

  data = loadTable("data.csv");
  Number_Days = data.getRowCount()-1;

  days = new Day[Number_Days];
  for (int i = 0; i < Number_Days - 1; i++) {
    days[i] = new Day(data.getString(i+1, 0), data.getInt(i+1, 1), data.getInt(i+1, 3), data.getFloat(i+1, 4), data.getInt(i+1, 6), data.getInt(i+1, 7) );
  }
}

void initValues() {
  Max_Steps       = getMaxInt(1);
  Min_Steps     = getMinInt(1);
  Max_Sleep     = getMaxInt(3);
  Min_Sleep     = getMinInt(3);
  Min_Rain    = getMinFloat(4);
  Max_Rain    = getMaxInt(4);
  Min_Max_Temp  = getMinInt(6); //This mean Minimum value of the High temperature range.
  Max_Max_Temp  = getMaxInt(6);
  Min_Min_Temp  = getMinInt(7);
  Max_Min_Temp  = getMaxInt(7);
}

void drawWindows() {
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
  int Window1_RangeX = Window1_EndX - Window1_StartX - 2*Data_Buffer;
  int Window1_RangeY = Window1_EndY - (Window1_StartY+2*Data_Buffer);
  float Window1_SteppingX = float(Window1_RangeX) / Number_Days;

  for (int i = 0; i < Number_Days-1; i++) {
    line((i*Window1_SteppingX)+Window1_StartX+Data_Buffer, Window1_EndY-Data_Buffer, (i*Window1_SteppingX)+Window1_StartX+Data_Buffer, Window1_EndY - Data_Buffer - map(getYAxisValue(i), getYAxisMinValue(), getYAxisMaxValue(), 0, Window1_RangeY));
  }
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

void keyPressed(){
  
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
  for (int i = 0; i < Number_Days; i++) {
    array[i] = data.getInt(i+1, col_num);
  }

  return max(array);
}

float getMaxFloat(int col_num) {
  float[] array = new float[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days; i++) {
    array[i] = data.getFloat(i+1, col_num);
  }

  return max(array);
}

 int getMinInt(int col_num) {
  int[] array = new int[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days; i++) {
    array[i] = data.getInt(i+1, col_num);
  }

  return min(array);
}

float getMinFloat(int col_num) {
  float[] array = new float[data.getRowCount() - 1];  
  for (int i = 0; i < Number_Days; i++) {
    array[i] = data.getFloat(i+1, col_num);
  }

  return min(array);
}












/*
For the Window 1 panel, this will be a bar graph of the temperature over time with a single point mark on each bar to indicate how many steps were walked, or something like that.
 The visual idiom is still being debated.
 
 The Window 2 panel will be the streched and enhanced version of the data selected from Window 1 with added details such as the weather that day, how much precipitation, etc.
 
 The window 3 panel will have the summary information from the Window 2 such as the average temperature during this time, the total number of steps, the number of days included in this
 selection, the begin date and end date, Standard deviation of the number of steps walked, avg precipitation over these days, etc.
 
 The window should be recizable and the data being shown should resize with the window as well. Including the text in the Window 3 panel.
 
 Should be able to sort data based on precipitation
 
 */