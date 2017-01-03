class Blob {
   
  int color_r;
  int color_g;
  int color_b;
  
  Gene[] chromosome;
  float fitness;
  
  //int split;
  int splitSize;
  int splitDistance;
  int foodOrBlob;
  //int eject;
  
  int timer;
  boolean isSplit;
  
  /*
  List of thingies for genetic code
  
  when it splits (distance at which it shoots at players)
    we can also include when its about to be attacked, like
      when it's near a bigger blob, it might want to shoot 
      to get away)
  how often it ejects mass
  who it targets (blobs or food)
    or rather at what size does it switch from food to blob)
  */
  
  int ID; //each blob gets a unique ID number instead of a name
  ArrayList<Piece> pieces;
  
  //the piece that stays in the center when the blob splits
  Piece main;
  
  Blob ( int s, int num ) {
    
    randomColor();
    ID = num;
    pieces = new ArrayList<Piece>();
    Piece p = new Piece(s, color_r, color_g, color_b, ID);
    main = p;
    pieces.add(main);
    isSplit = false;
    
    chromosome = new Gene[3];
    //size at which it splits
    chromosome[0] = new Gene(8);
    //distance at which it splits
    chromosome[1] = new Gene(4);
    //whether it goes after food or blobs
    chromosome[2] = new Gene(1);
    //when it ejects mass? distance from threat?
    //chromosome[2] = new Gene(4);
    
    splitSize = chromosome[0].value;
    splitDistance = chromosome[1].value;
    foodOrBlob = chromosome[2].value;
    
  }
  
  void evolve(Blob dead) {
   for (int i = 0; i < chromosome.length; i++) {
     for (int j = 0; j < chromosome[i].genotype.length; j++) {
       int part1 = chromosome[i].genotype[j];
       int part2 = dead.chromosome[i].genotype[j];
       if (part1 == part2) 
         if (random(1) > .25) 
           mutate();
       else 
         if (random(1) < .25)
           mutate();
     }
   }
  }
 
  void setFitness( Blob goal ) {
    int count = 0;
    int total = 0;
    for (int i = 0; i < chromosome.length; i++) {
      count += abs(chromosome[i].value - goal.chromosome[i].value);
      total += pow(2, chromosome[i].genotype.length) - 1;
    }
    fitness = (1 - (count * 1.0 / total)) * 100;
  }
  
  //two blobs are the same if they have the same ID
  boolean equals(Blob b) {
    if (ID == b.ID)
      return true;
    return false;
  }
  
  void mutate() {
    for (int i = 0; i < chromosome.length; i++) 
      if (random(2) < 1)
        chromosome[i].mutate();
  }
  
  void randomColor() {
    color_r = (int)random(256);
    color_g = (int)random(256);
    color_b = (int)random(256);  
  }
  
  void setCoords( int new_x, int new_y ) {
    for (int i = 0; i < pieces.size(); i++) {
      pieces.get(i).x_coord += new_x - main.x_coord;
      pieces.get(i).y_coord += new_y - main.y_coord;  
    }
  }
  
  void setMain() {
    if (pieces.size() != 0)
      main = pieces.get(0);
  }
  
  /*display coordinates are coordinates of food relative 
  to the display window*/
  void setRelativeCoords(int display_x, int display_y) {
    for (int i = 0; i < pieces.size(); i++) 
      pieces.get(i).setRelativeCoords(display_x, display_y);
  }
  
  //size of blob = sum of the size of the pieces
  int calcSize() {
    int s = 0;
    for (int i = 0; i < pieces.size(); i++) 
       s += pieces.get(i).size; 
    return s;
  }

  int compareTo(Blob c) {
    return calcSize() - c.calcSize();
  }
  
/*  void display() {
    Piece hold;
    for (int i = 0; i < pieces.size(); i++) {
      hold = pieces.get(i);
      beginShape();
      fill(color_r, color_g, color_b);
      ellipse(hold.relative_x, hold.relative_y, hold.size, hold.size);
      endShape();
      String s = ID + "";
      fill(0);
      text(s, hold.relative_x-4, hold.relative_y+4);
    }
  }
*/
  
  float distance(int their_x, int their_y) {
    return sqrt((their_x - main.x_coord) * (their_x - main.x_coord) + (their_y - main.y_coord) * (their_y - main.y_coord));  
  }
  
  //in order to move toward an object, all of the pieces of the blob
  //must move
  void moveTowards(int target_x, int target_y) {
    float theta = 0;
    if ((target_x - main.x_coord) != 0) {
      theta = (target_y - main.y_coord) / (target_x - main.x_coord);
    }
    Piece hold;
    if (main.x_coord > target_x && main.y_coord > target_y) { 
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord -= (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord -= (int)((sin(atan(theta))) * hold.speed());
      }
    }
    else {
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord += (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord += (int)((sin(atan(theta))) * hold.speed());
      }
    }  
  }
  
  void avoid(int scary_x, int scary_y) {
    float theta = 0;
    if ((scary_x - main.x_coord) != 0) {
      theta = (scary_y - main.y_coord) / (scary_x - main.x_coord);
    }
    Piece hold;
    if (main.x_coord > scary_x && main.y_coord > scary_y) { 
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord += (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord += (int)((sin(atan(theta))) * hold.speed());
      }
    }
    else if (main.x_coord > scary_x && main.y_coord < scary_y) {
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord += (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord -= (int)((sin(atan(theta))) * hold.speed());
      }
    }
    else if (main.x_coord < scary_x && main.y_coord > scary_y) {
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord -= (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord += (int)((sin(atan(theta))) * hold.speed());
      }
    }    
    else {
      for (int i = 0; i < pieces.size(); i++) { 
        hold = pieces.get(i);
        hold.x_coord -= (int)((cos(atan(theta))) * hold.speed());
        hold.y_coord -= (int)((sin(atan(theta))) * hold.speed());
      }
    }
  }
   
  //splits each of the blob's pieces into two pieces, each half
  //the size of the original. The pieces must be at least a certain
  //size before it can split
  void split(int target_x, int target_y) {
    Piece hold;
    int meow = pieces.size();
    boolean bigEnough = true;
    for (int i = 0; i < meow; i++) {
      hold = pieces.get(i);
      if (hold.size < 40) {
        bigEnough = false;
      }
    }
    if (bigEnough == true) {
      ArrayList<Piece> replace = new ArrayList<Piece>();
      for (int i = 0; i < meow; i++) {
        hold = pieces.get(i);
        Piece p = new Piece(hold.size/2, color_r, color_g, color_b, ID);
        Piece p1 = new Piece(hold.size/2, color_r, color_g, color_b, ID);
        p.setCoords(hold.x_coord, hold.y_coord);
        p1.setCoords(hold.x_coord, hold.y_coord);
        p1.shootForward(target_x, target_y);
        replace.add(p);
        replace.add(p1);
      }
      pieces = replace;
      setMain();
    }
    isSplit = true;
  }
  
  void resetTimer() {
    timer = 0;  
  }
  
  void merge(int display_x, int display_y) {
    //println(pieces.get(0).size);
    Piece p = new Piece(calcSize(), color_r, color_g, color_b, ID);
    p.setCoords(main.x_coord, main.y_coord);
    p.setRelativeCoords(display_x, display_y);
    ArrayList<Piece> al = new ArrayList<Piece>();
    main = p;
    al.add(main);
    pieces = al;
    isSplit = false;
    println("meow");
  }
  
}

