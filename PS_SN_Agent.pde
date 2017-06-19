import hypermedia.net.*;

//final static boolean DBG = true;
final static boolean DBG = false;

final static int PS_SN_SURFACE_W = 300;
final static int PS_SN_SURFACE_H = 640;

UDP PS_SN_handle = null;  // The handle of PS_SN
UDP PS_Device_handle = null;  // The handle of PS_Device

String PS_SN_remote_ip = "localhost"; //null;
String PS_SN_local_ip = "localhost"; //null;
int PS_SN_local_port = 1024;
String PS_Device_remote_ip_base = "10.0.";
int PS_Device_remote_port = 1024;
int PS_Device_local_port = 1025;

boolean PS_SN_started = true;

int PS_SN_logs_index = 0;
int PS_SN_logs_length = PS_SN_SURFACE_H/15;
String[] PS_SN_logs_array = new String[PS_SN_logs_length];
boolean PS_SN_logs_stop = false;

int PS_SN_BTN_X, PS_SN_BTN_Y, PS_SN_BTN_W, PS_SN_BTN_H;
int PS_SN_BTM_C_normal = 255;
int PS_SN_BTM_C_over = 192;
int PS_SN_BTM_C_pressed = 128;
int PS_SN_BTM_C_current = PS_SN_BTM_C_normal;

void settings() {
/*
  try {
    if( args.length >= 1) {
      UDP_remote_ip = args[0];
    }
  }
  catch (Exception e) {
    // Nothing to do.
  }
*/
  size(PS_SN_SURFACE_W, PS_SN_SURFACE_H);
}

void setup()
{
  //println("PS_SN_logs_length="+PS_SN_logs_length);
  // Create a new datagram connection on local port
  // and wait for incomming message
  //UDP._log(true);
  PS_SN_handle = new UDP(this, PS_SN_local_port, PS_SN_local_ip);
  //PS_SN_handle = new UDP(this, PS_SN_local_port);
  //PS_SN_handle.log( true );
  PS_SN_handle.log( false );
  PS_SN_handle.setReceiveHandler( "PS_SN_receive_event" );
  PS_SN_handle.listen( true );

  PS_Device_handle = new UDP(this, PS_Device_local_port);
  //PS_Device_handle.log( true );
  PS_Device_handle.log( false );
  PS_Device_handle.setReceiveHandler( "PS_Device_receive_event" );
  PS_Device_handle.listen( true );
  
  //surface.setTitle("PS_SN_Agent " + PS_SN_local_port + "," + PS_SN_local_ip + "," + PS_Device_local_port);
  surface.setTitle("PS_SN_Agent " + PS_SN_local_port + "," + PS_Device_local_port);
}

void reset()
{
  if(PS_SN_handle != null)
  {
    PS_SN_handle.close();
    PS_SN_handle = null;
  }

  if(PS_Device_handle != null)
  {
    PS_Device_handle.close();
    PS_Device_handle = null;
  }
}

void draw()
{
  int i = PS_SN_logs_index;

  background(0); // black

  fill(255); // white
  for(int y = 15; y < PS_SN_SURFACE_H; y += 15)
  {
    if(PS_SN_logs_array[i] != null) text(PS_SN_logs_array[i], 5, y);
    i = (i += 1) % PS_SN_logs_length;
  }

  String b;
  if(PS_SN_started)
    b = "STOP";
  else
    b = "START";
  PS_SN_BTN_X = PS_SN_SURFACE_W - (int(textWidth(b)) + 5 * 2) - 5;
  PS_SN_BTN_Y = 5;
  PS_SN_BTN_W = int(textWidth(b)) + 5 * 2; 
  PS_SN_BTN_H = 12 + 5 * 2;

  if( (mouseX >= PS_SN_BTN_X && mouseX <= PS_SN_BTN_X + PS_SN_BTN_W)
      &&
      (mouseY >= PS_SN_BTN_Y && mouseY <= PS_SN_BTN_Y + PS_SN_BTN_H))
  {
    if(mousePressed)
      PS_SN_BTM_C_current = PS_SN_BTM_C_pressed;
    else
      PS_SN_BTM_C_current = PS_SN_BTM_C_over;
  }
  else
  {
    PS_SN_BTM_C_current = PS_SN_BTM_C_normal;
  }

  fill(PS_SN_BTM_C_current); // white
  rect(PS_SN_BTN_X, PS_SN_BTN_Y, PS_SN_BTN_W, PS_SN_BTN_H);
  fill(0); // black
  text(b, PS_SN_BTN_X + 5, PS_SN_BTN_Y + 12 + 5); 
}

void mousePressed()
{
  if( (mouseX >= PS_SN_BTN_X && mouseX <= PS_SN_BTN_X + PS_SN_BTN_W)
      &&
      (mouseY >= PS_SN_BTN_Y && mouseY <= PS_SN_BTN_Y + PS_SN_BTN_H))
  {
    // Nothing to do.
  }
  else
  {
    PS_SN_logs_stop = true;
  }
}

void mouseReleased()
{
  if( (mouseX >= PS_SN_BTN_X && mouseX <= PS_SN_BTN_X + PS_SN_BTN_W)
      &&
      (mouseY >= PS_SN_BTN_Y && mouseY <= PS_SN_BTN_Y + PS_SN_BTN_H))
  {
    if(PS_SN_started)
    {
      reset();
      PS_SN_started = false;
      PS_SN_logs_array[PS_SN_logs_index] = "PS_SN_Agent service stoped!";
      PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
      //println("PS_SN_logs_index="+PS_SN_logs_index);
    }
    else
    {
      setup();
      PS_SN_started = true;
      PS_SN_logs_array[PS_SN_logs_index] = "PS_SN_Agent service started!";
      PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
      //println("PS_SN_logs_index="+PS_SN_logs_index);
    }
  }
  else
  {
    PS_SN_logs_stop = false;
  }
}


void PS_SN_receive_event(byte[] data, String ip, int port)
{
  String PS_Device_remote_ip;
  byte[] out;
  
  if(DBG) println("PS_SN_receive_event data.length=" + data.length);

  if(data.length < 3) return;
  
  PS_Device_remote_ip = PS_Device_remote_ip_base + int(data[0]) + "." + int(data[1]);
  if(DBG) println("PS_SN_receive_event PS_Device_remote_ip=" + PS_Device_remote_ip);

  out = java.util.Arrays.copyOfRange(data, 2, data.length);
  if(DBG) println("PS_SN_receive_event out.length=" + out.length);
/*
  System.arraycopy(data, 2, data, 0, data.length - 2);
  data.length = data.length - 2;
  println("PS_SN_receive_event data.length=" + data.length);
*/

  PS_Device_handle.send(out, PS_Device_remote_ip, PS_Device_remote_port);
  if(!PS_SN_logs_stop)
  {
    PS_SN_logs_array[PS_SN_logs_index] = PS_SN_local_ip+":"+port+","+PS_SN_local_port+","+data.length+","+data[0]+data[1]+"->"+PS_Device_remote_ip+","+PS_Device_remote_port+","+out.length;
    PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
    //println("PS_SN_logs_index="+PS_SN_logs_index);
  }
}

void PS_Device_receive_event(byte[] data, String ip, int port)
{
  int PS_SN_remote_port;
  String[] ip_split = ip.split("\\.");

  if(DBG) println("PS_Device_receive_event ip=" + ip + " port=" + port + " data.length=" + data.length);

  PS_SN_remote_port = 10000 + Integer.parseInt(ip_split[2]) * 100 + Integer.parseInt(ip_split[3]);
  if(DBG) println("PS_Device_receive_event PS_SN_remote_port=" + PS_SN_remote_port);
  PS_SN_handle.send(data, PS_SN_remote_ip, PS_SN_remote_port);
  if(!PS_SN_logs_stop)
  {
    PS_SN_logs_array[PS_SN_logs_index] = ip+":"+port+","+PS_Device_local_port+","+data.length+"->"+PS_SN_remote_ip+","+PS_SN_remote_port+","+data.length;
    PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
    //println("PS_SN_logs_index="+PS_SN_logs_index);
  }
}