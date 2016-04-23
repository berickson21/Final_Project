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

int[] data;

int Bar_Buffer = 4;

void setup() {
  size(1600, 1000);
  surface.setResizable(true);
  data = new int[272];
  createData();
  frameRate(5);
}

void draw() {
  background(100);
  drawWindows();
  drawData();
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

void createData() {
  for (int i = 0; i < 272; i++) {
    data[i] = int(random(100));
  }
}

void drawData() {
  int Window1_RangeX = Window1_EndX - Window1_StartX - 2*Data_Buffer;
  float Window1_SteppingX = float(Window1_RangeX) / 271;
  
  int Window1_RangeY = Window1_EndY - (Window1_StartY+2*Data_Buffer);
  
  // int drawLocationX = 0;
  beginShape();
  strokeWeight(1);
  for (int i = 0; i < 272; i++) {
    
    vertex((i*Window1_SteppingX)+Window1_StartX+Data_Buffer, Window1_EndY - Data_Buffer - map(data[i], 0, 100, 0, Window1_RangeY));
  }
  endShape();
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