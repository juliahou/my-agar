class food {

  int color_r;
  int color_g;
  int color_b;
    
  int x_coord;
  int y_coord;
  
  int relative_x;
  int relative_y;
  
  int food_size;
  
  food(int x, int y, int f) {
    setCoords(x,y);
    randomColor();
    food_size = f;
  }
  
  /*display coordinates are coordinates of food relative 
  to the display window*/
  void setRelativeCoords(int display_x, int display_y) {
    relative_x = x_coord - display_x;
    relative_y = y_coord - display_y;
  }
  
  void randomColor() {
    color_r = (int)random(256);
    color_g = (int)random(256);
    color_b = (int)random(256);  
  }
  
  void display() {
    beginShape();
    fill(color_r, color_g, color_b);
    ellipse(relative_x, relative_y, food_size, food_size);
    endShape();
  }
  
  void setCoords(int x, int y) {
    x_coord = x;
    y_coord = y;  
  }
  
  boolean isInDisplay(int display_x, int display_y, int display_size) {
    if (x_coord > display_x && x_coord < display_x + display_size && y_coord > display_y && y_coord < display_y + display_size)
      return true;
    return false;
  }
  
}

