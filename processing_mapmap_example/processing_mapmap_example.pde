/**
 * Saves the rendering of this Processing sketch and sends an OSC message to MapMap.
 *
 * Usage:
 * Press 's' to enable/disable frame saving to MapMap
 */
 
 // CONFIGURATION:
static final int MAPMAP_OSC_RECEIVE_PORT = 12345; // MapMap's default OSC receive port.
static final String OSC_ADDR_SEND_HOST = "localhost";
static final int MAPMAP_MEDIA_ID = 0; // The source in MapMap
static final int FPS = 24;

// imports
import netP5.*;
import oscP5.*;

// business logic variables
boolean save_to_mapmap_enabled = true; // let's enable it by default
int current_frame_number = 0;
static final int OSC_ADDR_RECV_PORT = 18939; // useless
OscP5 oscP5;
NetAddress address_to_send_to;

void setup()
{
  size(320, 240, P3D);
  frameRate(FPS);
  oscP5 = new OscP5(this, OSC_ADDR_RECV_PORT);
  address_to_send_to = new NetAddress(OSC_ADDR_SEND_HOST, MAPMAP_OSC_RECEIVE_PORT);
}

String make_frame_file_name()
{
  current_frame_number = (current_frame_number + 1) % 10;
  return "/tmp/to_mapmap_" + current_frame_number + ".jpg";
}

void draw()
{
  background(0, 127, 0);
  fill(0, 255, 0);
  ellipse(mouseX, mouseY, 75, 75);

  if (save_to_mapmap_enabled)
  {
    String file_name = make_frame_file_name();
    saveFrame(file_name);
    send_mapmap_load_media(MAPMAP_MEDIA_ID, file_name);
  }
}

void send_mapmap_load_media(int media_id, String file_name)
{   
  OscMessage myMessage = new OscMessage("/mapmap/paint/media/load");
  myMessage.add(media_id);
  myMessage.add(file_name);
  oscP5.send(myMessage, address_to_send_to); 
}

void toggle_save_to_mapmap()
{
  save_to_mapmap_enabled = ! save_to_mapmap_enabled;
}

void keyPressed()
{
  switch(key)
  {
  case 's':
    toggle_save_to_mapmap();
    break;
  }
}