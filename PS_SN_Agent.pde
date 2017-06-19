import hypermedia.net.*;

//final static boolean DBG = true;
final static boolean DBG = false;

final static int PS_SN_SURFACE_W = 350;
final static int PS_SN_SURFACE_H = 640;

UDP PS_SN_handle = null;  // The handle of PS_SN
UDP PS_Device_handle = null;  // The handle of PS_Device

String PS_SN_remote_ip = "localhost"; //null;
String PS_SN_local_ip = "localhost"; //null;
int PS_SN_local_port = 1024;
String PS_Device_remote_ip_base = "10.0.";
int PS_Device_remote_port = 1024;
int PS_Device_local_port = 1025;

int PS_SN_logs_index = 0;
int PS_SN_logs_length = PS_SN_SURFACE_H/15;
String[] PS_SN_logs_array = new String[PS_SN_logs_length];
boolean PS_SN_logs_stop = false;

boolean PS_SN_SERVICE_started = true;

int PS_SN_BTN_SERVICE_X, PS_SN_BTN_SERVICE_Y, PS_SN_BTN_SERVICE_W, PS_SN_BTN_SERVICE_H;
int PS_SN_BTN_SERVICE_C_normal = 255;
int PS_SN_BTN_SERVICE_C_over = 192;
int PS_SN_BTN_SERVICE_C_pressed = 128;
int PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_normal;

boolean PS_SN_LOG_first = true;
boolean PS_SN_LOG_on = false;

int PS_SN_BTN_LOG_X, PS_SN_BTN_LOG_Y, PS_SN_BTN_LOG_W, PS_SN_BTN_LOG_H;
int PS_SN_BTN_LOG_C_normal = 255;
int PS_SN_BTN_LOG_C_over = 192;
int PS_SN_BTN_LOG_C_pressed = 128;
int PS_SN_BTN_LOG_C_current = PS_SN_BTN_LOG_C_normal;

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

  int i;
  for(i = 0; i < PS_SN_logs_length - 1; i ++)
  {
    PS_SN_logs_array[i] = "";
  }
  PS_SN_logs_array[i] = millis() + ":PS_SN_Agent service started!";
  PS_SN_logs_array[i-1] = millis() + ":PS_SN_Agent service started!";

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
  background(0); // black

  if(PS_SN_LOG_on || PS_SN_LOG_first)
  {
    fill(255); // white
    int i = PS_SN_logs_index;
    for(int y = 15; y < PS_SN_SURFACE_H; y += 15)
    {
      //if(PS_SN_logs_array[i] != null)
        text(PS_SN_logs_array[i], 5, y);
      i = (i += 1) % PS_SN_logs_length;
    }
    PS_SN_LOG_first = false;
  }

  String b;
  if(PS_SN_SERVICE_started)
    b = "STOP";
  else
    b = "START";
  PS_SN_BTN_SERVICE_X = PS_SN_SURFACE_W - (int(textWidth(b)) + 5 * 2) - 5;
  PS_SN_BTN_SERVICE_Y = 5;
  PS_SN_BTN_SERVICE_W = int(textWidth(b)) + 5 * 2; 
  PS_SN_BTN_SERVICE_H = 12 + 5 * 2;

/*
  if( (mouseX >= PS_SN_BTN_SERVICE_X && mouseX <= PS_SN_BTN_SERVICE_X + PS_SN_BTN_SERVICE_W)
      &&
      (mouseY >= PS_SN_BTN_SERVICE_Y && mouseY <= PS_SN_BTN_SERVICE_Y + PS_SN_BTN_SERVICE_H))
  {
    if(mousePressed)
      PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_pressed;
    else
      PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_over;
  }
  else
  {
    PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_normal;
  }
*/

  fill(PS_SN_BTN_SERVICE_C_current); // white
  rect(PS_SN_BTN_SERVICE_X, PS_SN_BTN_SERVICE_Y, PS_SN_BTN_SERVICE_W, PS_SN_BTN_SERVICE_H);
  fill(0); // black
  text(b, PS_SN_BTN_SERVICE_X + 5, PS_SN_BTN_SERVICE_Y + 12 + 5); 
}

void mousePressed()
{
  if( (mouseX >= PS_SN_BTN_SERVICE_X && mouseX <= PS_SN_BTN_SERVICE_X + PS_SN_BTN_SERVICE_W)
      &&
      (mouseY >= PS_SN_BTN_SERVICE_Y && mouseY <= PS_SN_BTN_SERVICE_Y + PS_SN_BTN_SERVICE_H))
  {
    PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_pressed;
  }
  else
  {
    PS_SN_logs_stop = true;
  }
}

void mouseReleased()
{
  PS_SN_BTN_SERVICE_C_current = PS_SN_BTN_SERVICE_C_normal;
  if( (mouseX >= PS_SN_BTN_SERVICE_X && mouseX <= PS_SN_BTN_SERVICE_X + PS_SN_BTN_SERVICE_W)
      &&
      (mouseY >= PS_SN_BTN_SERVICE_Y && mouseY <= PS_SN_BTN_SERVICE_Y + PS_SN_BTN_SERVICE_H))
  {
    if(PS_SN_SERVICE_started)
    {
      reset();
      PS_SN_SERVICE_started = false;
      PS_SN_logs_array[PS_SN_logs_index] = millis() + ":PS_SN_Agent service stoped!";
      PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
      //println("PS_SN_logs_index="+PS_SN_logs_index);
    }
    else
    {
      setup();
      PS_SN_SERVICE_started = true;
      PS_SN_logs_array[PS_SN_logs_index] = millis() + ":PS_SN_Agent service started!";
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
    PS_SN_logs_array[PS_SN_logs_index] = millis()+":"+PS_SN_local_ip+":"+port+","+PS_SN_local_port+","+data.length+","+data[0]+data[1]+"->"+PS_Device_remote_ip+","+PS_Device_remote_port+","+out.length;
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
    PS_SN_logs_array[PS_SN_logs_index] = millis()+":"+ip+":"+port+","+PS_Device_local_port+","+data.length+"->"+PS_SN_remote_ip+","+PS_SN_remote_port+","+data.length;
    PS_SN_logs_index = (PS_SN_logs_index += 1) % PS_SN_logs_length;
    //println("PS_SN_logs_index="+PS_SN_logs_index);
  }
}