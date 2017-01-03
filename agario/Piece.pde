/*piece of a blob (in cases where the blob has not yet split at all,
the piece functions as a big blob (they're pretty much the 
same thing)*/
class Piece {
  
  int x_coord;
  int y_coord;
  
  int relative_x;
  int relative_y;
  
  int color_r;
  int color_g;
  int color_b;
  
  //diameter
  int size;
  
  float area;
  
  float direction = 0;
  float velocity = 0;
  float max_velocity = 0;
  
  int ID;
  
  Piece(int s, int r, int g, int b, int num) {
    size = s;
    color_r = r;
    color_g = g;
    color_b = b;
    ID = num;
  }

  void setCoords( int new_x, int new_y ) {
    x_coord = new_x;
    y_coord = new_y;  
  }
  
  /*display coordinates are coordinates of food relative 
  to the display window*/
  void setRelativeCoords(int display_x, int display_y) {
    relative_x = x_coord - display_x;
    relative_y = y_coord - display_y;
  }
  
  float distance(int their_x, int their_y) {
    return sqrt((their_x - x_coord) * (their_x - x_coord) + (their_y - y_coord) * (their_y - y_coord));  
  }
  
  int compareTo(Piece c) {
    return size - c.size;
  }
  
  int speed() {
    //calculate velocity based on size
    return 200/size + 1;
  }
  
  boolean isInDisplay(int display_x, int display_y, int display_size) {
    if (x_coord > display_x && x_coord < display_x + display_size && y_coord > display_y && y_coord < display_y + display_size)
      return true;
    return false;
  }
  
  void moveTowards(int x, int y) {
    if (x_coord < x)
      x_coord++;
    else
      x_coord--;
    if (y_coord < y)
      y_coord++;
    else
      y_coord--;
  }    
  
  void avoid(int x, int y) {
    if (x_coord < x)
      x_coord--;
    else
      x_coord++;
    if (y_coord < y)
      y_coord--;
    else
      y_coord++;
  }
  
  void shootForward(int x, int y) {
    float theta = 0;
    if ((x - x_coord) != 0)
      theta = (y - y_coord) / (x - x_coord);
    if (x_coord > x && y_coord > y) { 
      x_coord += (int)((cos(atan(theta))) * speed()) * 10;
      y_coord += (int)((sin(atan(theta))) * speed()) * 10;
    }
    else if (x_coord > x && y_coord < y) {
      x_coord += (int)((cos(atan(theta))) * speed()) * 10;
      y_coord -= (int)((sin(atan(theta))) * speed()) * 10;
    }
    else if (x_coord < x && y_coord > y) {
      x_coord -= (int)((cos(atan(theta))) * speed()) * 10;
      y_coord += (int)((sin(atan(theta))) * speed()) * 10;
    }    
    else {
      x_coord -= (int)((cos(atan(theta))) * speed()) * 10;
      y_coord -= (int)((sin(atan(theta))) * speed()) * 10;
    }
  }
   
  void display() {
    beginShape();
    fill(color_r, color_g, color_b);
    ellipse(relative_x, relative_y, size, size);
    endShape();
    String s = ID + "";
    fill(0);
    text(s, relative_x-4, relative_y+4);
  }
  
  void addToSize(int add) {
    area += add;
    size += (int)sqrt(area/PI);
  }

}

