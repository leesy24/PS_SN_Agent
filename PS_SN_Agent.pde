import hypermedia.net.*;

//final static boolean DBG = true;
final static boolean DBG = false;

UDP PS_SN_handle = null;  // The handle of PS_SN
UDP PS_Device_handle = null;  // The handle of PS_Device

String PS_SN_remote_ip = "localhost"; //null;
String PS_SN_local_ip = "localhost"; //null;
int PS_SN_local_port = 1024;
String PS_Device_remote_ip_base = "10.0.";
int PS_Device_remote_port = 1024;
int PS_Device_local_port = 1025;

int SN_rcv_data_length;
String Device_remote_ip;
int Device_remote_port;
int Device_rcv_data_length;

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
  size(200, 200);
}

void setup()
{
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
}

void draw()
{
  int y = 0;
  background(0);
  text("PS_SN_Agent " + PS_SN_local_ip + "," + PS_SN_local_port, 5, y += 20);
  text(SN_rcv_data_length, 5, y += 20);
  text(Device_remote_ip!=null?Device_remote_ip:"no ip", 5, y += 20);
  text(Device_remote_port, 5, y += 20);
  text(Device_rcv_data_length, 5, y += 20);
}

//void PS_SN_receive_event(byte[] data, String ip, int port)
void PS_SN_receive_event(byte[] data)
{
  String PS_Device_remote_ip;
  byte[] out;
  
  if(DBG) println("PS_SN_receive_event data.length=" + data.length);

  SN_rcv_data_length = data.length;

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
}

void PS_Device_receive_event(byte[] data, String ip, int port)
{
  int PS_SN_remote_port;
  String[] ip_split = ip.split("\\.");

  if(DBG) println("PS_Device_receive_event ip=" + ip + " port=" + port + " data.length=" + data.length);

  Device_remote_ip = ip;
  Device_remote_port = port;
  Device_rcv_data_length = data.length;

  PS_SN_remote_port = 10000 + Integer.parseInt(ip_split[2]) * 100 + Integer.parseInt(ip_split[3]);
  if(DBG) println("PS_Device_receive_event PS_SN_remote_port=" + PS_SN_remote_port);
  PS_SN_handle.send(data, PS_SN_remote_ip, PS_SN_remote_port);
}