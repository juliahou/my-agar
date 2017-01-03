/**
  *  DW Period 3
  *  Created by JJ
**/
import java.util.*;

int num_blobs = 300;
int initial_blob_size = 20;
int num_food = 4000;
int food_size = 5;

int world_size = 10000;
int display_size = 800;

//coordinates of the top left corner of the display
int display_x;
int display_y;

Blob[] thingy = new Blob[num_blobs];
Blob player;
food[] other_thingy = new food[num_food];

void setup() {
  size(display_size, display_size);
  //Blob 0 is player
  for(int i = 0; i < num_blobs; i++) {
    thingy[i] = new Blob(initial_blob_size, i);
    thingy[i].setCoords((int)random(world_size), (int)random(world_size));
  }
  player = thingy[0];
  for(int i = 0; i < num_food; i++) {
    other_thingy[i] = new food((int)random(world_size), (int)random(world_size), food_size);
  }
  setDisplayCoords();
}

/*
checks the current coordinates of the player and adjusts   
the coordinates of the display to maintain the player in the
center
*/
void setDisplayCoords() {
  display_x = player.main.x_coord - display_size / 2;
  display_y = player.main.y_coord - display_size / 2;
  if (display_x < 0)
    display_x = 0;
  if (display_y < 0)
    display_y = 0;
  if (display_x > (world_size - display_size / 2))
    display_x = world_size - display_size / 2;
  if (display_y > (world_size - display_size / 2))
    display_y = world_size - display_size / 2;
}

void draw() {
  
  background(255);
  setDisplayCoords();
  
  for(int i = 0; i < num_food; i++) {
    if (other_thingy[i].isInDisplay(display_x, display_y, display_size)) {
      other_thingy[i].setRelativeCoords(display_x, display_y);
      other_thingy[i].display();
    }
  }  
  
  for(int i = 0; i < num_blobs; i++) {
    
    food min = other_thingy[0];
    //calculates food that is minimum distance away
    for (int j = 0; j < num_food; j++) {
      for (int k = 0; k < thingy[i].pieces.size(); k++) {
        Piece hold = thingy[i].pieces.get(k);
        float distance = hold.distance(other_thingy[j].x_coord, other_thingy[j].y_coord);
        if (distance < hold.size/2) {
          hold.addToSize(other_thingy[j].food_size);
          //hold.size += other_thingy[j].food_size/2;
          other_thingy[j].setCoords((int)random(world_size), (int)random(world_size));
        }
        else if (distance < thingy[i].distance(min.x_coord, min.y_coord))
          min = other_thingy[j];
      }
    }
   
    //calculates blob piece that is minimum distance away (and smaller)
    Piece min1 = thingy[0].pieces.get(0);
    Piece avoid = thingy[0].pieces.get(0);
    //goes through all the blobs, excluding the current one
    for (int k = 0; k < num_blobs; k++) {
      if (!thingy[i].equals(thingy[k])) {
          //goes through all the pieces of the other blob
          for (int m = 0; m < thingy[k].pieces.size(); m++) {
            Piece mainHold = thingy[i].main;
            Piece otherHold = thingy[k].pieces.get(m);
            float distance = mainHold.distance(otherHold.x_coord, otherHold.y_coord);
            //if the current blob is bigger than the other one, it gets eaten
            if (mainHold.compareTo(otherHold) > 0) {
              if (distance < mainHold.size/2) {
                mainHold.addToSize(otherHold.size);
                //mainHold.size += otherHold.size/2;
                thingy[k].pieces.remove(m);
              }
              else if (distance < mainHold.distance(min1.x_coord, min1.y_coord)) {
                min1 = otherHold;
              }
            }
            //if other blob is bigger, avoid it
            //if other blob is close enough, it eats main blob piece
            else if (mainHold.compareTo(otherHold) < 0) {
              if (distance < mainHold.size/2) {
                otherHold.addToSize(mainHold.size);
                //otherHold.size += mainHold.size/2;
                if (thingy[i].pieces.size() != 0)
                  thingy[i].pieces.remove(0);
                if (thingy[i].pieces.size() != 0) {
                    thingy[i].setMain();
                }
                else {
                  if (thingy[i].equals(player)) {
                    exit();
                  }
                  else {
                    Blob dead = thingy[i];
                    Blob b = new Blob(initial_blob_size, thingy[i].ID);
                    b.setCoords((int)random(world_size), (int)random(world_size));
                    thingy[i] = b;
                    for (int n = 0; n < num_blobs; n++) 
                      if (!thingy[n].equals(player)) 
                        thingy[n].evolve(dead);
                    }
                  }
                }
                else if (distance < mainHold.distance(avoid.x_coord, avoid.y_coord)) {
                  avoid = otherHold;
                }
              }
            }
        }
      }
    //}
      if (thingy[i].pieces.size() == 0) {
        if (thingy[i].equals(player)) {
          //stop
        }
        else {
          Blob dead = thingy[i];
          Blob b = new Blob(initial_blob_size, thingy[i].ID);
          b.setCoords((int)random(world_size), (int)random(world_size));
          thingy[i] = b;
          for (int n = 0; n < num_blobs; n++) 
          if (!thingy[n].equals(player)) 
             thingy[n].evolve(dead);
        }
      }
 
    //to keep pieces from overlapping each other and to keep them together
    for (int j = 0; j < thingy[i].pieces.size(); j++) {
      for (int k = 0; k < thingy[i].pieces.size(); k++) {
        if (j != k) {
          Piece hold1 = thingy[i].pieces.get(j);
          Piece hold2 = thingy[i].pieces.get(k);
          if (hold1.distance(hold2.x_coord, hold2.y_coord) < (hold1.size + hold2.size)/2) {
            hold1.avoid(hold2.x_coord, hold2.y_coord);
          }
          if (hold1.distance(hold2.x_coord, hold2.y_coord) > (hold1.size + hold2.size)/2) {
            hold1.moveTowards(hold2.x_coord, hold2.y_coord);
          }
        }
      }
    }
        
    //blobs move toward target
    if (!thingy[i].equals(player)) {
      //println(avoid.ID);
      //all blobs primarily avoid threats
      if (thingy[i].distance(avoid.x_coord, avoid.y_coord) < 20)
        thingy[i].avoid(avoid.x_coord, avoid.y_coord);
      //once blob has certain smarts, it starts targeting blobs
      //else if (thingy[i].calcSize() > 50) {
      else if (thingy[i].foodOrBlob == 1) {
        min1.setRelativeCoords(display_x, display_y);
        if (thingy[i].distance(min1.x_coord, min1.y_coord) > thingy[i].splitDistance && thingy[i].calcSize() > thingy[i].splitSize) {
          thingy[i].split(min1.x_coord, min1.y_coord);
        }
        else {
          thingy[i].moveTowards(min1.x_coord, min1.y_coord);
        }
      }
      else {
        min.setRelativeCoords(display_x, display_y);
        thingy[i].moveTowards(min.x_coord, min.y_coord);
       //thingy[i].setCoords(thingy[i].x_coord + (int)(thingy[i].speed()/thingy[i].distance(min.x_coord, min.y_coord)), (int)(thingy[i].speed()/thingy[i].distance(min.x_coord, min.y_coord)));
      }  
    }
    //println(thingy[i].pieces.size());
   
    //player moves toward mouse
    if (thingy[i] == player) {
      for (int j = 0; j < player.pieces.size(); j++) {
        Piece hold = thingy[i].pieces.get(j);
        hold.setCoords(hold.x_coord + (mouseX - 400)*hold.speed()/200, hold.y_coord + (mouseY - 400)*hold.speed()/200);
      }
    }
    //keeps blobs within the world
    for (int j = 0; j < thingy[i].pieces.size(); j++) {
      Piece hold = thingy[i].pieces.get(j);
      if (hold.x_coord > world_size-1)
        hold.x_coord = world_size-1;
      if (hold.x_coord < 1)
        hold.x_coord = 1;
      if (hold.y_coord > world_size-1)
        hold.y_coord = world_size-1;
      if (hold.y_coord < 1)
        hold.y_coord = 1;
    }
    thingy[i].setRelativeCoords(display_x, display_y);
    for (int j = 0; j < thingy[i].pieces.size(); j++) {
      Piece hold = thingy[i].pieces.get(j);
      if (hold.isInDisplay(display_x, display_y, display_size)) {
        hold.display();
      }
    }
    if (thingy[i].isSplit == true)
      thingy[i].timer++;
    if (thingy[i].timer == thingy[i].calcSize() * 5) {
      thingy[i].merge(display_x, display_y);
      /*if (thingy[i].ID == 0)
        player = thingy[i];*/
      //println(thingy[i].pieces.size());
      thingy[i].resetTimer();
    }
  } 
  
  leaderboard();
  /*player.setCoords(player.x_coord + (mouseX - 400)/100, player.y_coord + (mouseY - 400)/100); 
  if (player.x_coord > world_size)
    player.x_coord = world_size;
  if (player.x_coord < 0)
    player.x_coord = 0;
  if (player.y_coord > world_size)
    player.y_coord = world_size;
  if (player.y_coord < 0)
    player.y_coord = 0;*/
  //make it so player can't leave world
  //move(mouseX - (display_size/2), mouseY - (display_size/2));
  println(mouseX + "," + mouseY);
  delay(10);
}


void keyPressed() {
  //if space key is pressed, the player splits
  if (key == ' ') {
    player.split(mouseX, mouseY);
  }
}
    
Blob[] merge( Blob[] a, Blob[] b )  {
  Blob[] sorted = new Blob[ a.length + b.length ];
  int acount = 0;
  int bcount = 0;
  int scount = 0;
  while ( acount < a.length && bcount < b.length ) {
    if ( a[acount].compareTo(b[bcount]) > 0 ) {
      sorted[scount] = a[acount];
      acount++;
    }
    else {
      sorted[scount] = b[bcount];
      bcount++;
    }
    scount++;      
  }
  while ( acount < a.length ) {
    sorted[scount] = a[acount];
    scount++;
    acount++;
  }
  while ( bcount < b.length ) {
    sorted[scount] = b[bcount];
    scount++;
    bcount++;
  }        
  return sorted;
}

Blob[] mergeSort(Blob[] list) {
  if (list.length == 1)
    return list;
  else {
    int mid = list.length/2;
    Blob[] a = new Blob[mid];
    Blob[] b = new Blob[list.length - mid];
    for (int i = 0; i < a.length; i++)
      a[i] = list[i];
    for (int j = 0; j < b.length; j++)
      b[j] = list[mid + j];
    return merge(mergeSort(a), mergeSort(b));
  }
}

void leaderboard() {
  thingy = mergeSort(thingy);
  String s;
  for (int i = 0; i < 10; i++) {
    s = (i+1) + ". Blob " + thingy[i].ID;
    if (s.equals((i+1) + ". Blob 0"))
      s = (i+1) + ". You";
    fill(0);
    text(s, display_size - 100, 10*(i+3));
  }
}
  
