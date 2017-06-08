#include "printf.h"
#include <Timer.h>
#include "DiscoProtocol.h"

configuration DiscoProtocolAppC {
} 
implementation {
  components MainC;
  components LedsC;
  components DiscoProtocolC as App;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components ActiveMessageC;
  components HplMsp430GeneralIOC;
  components new AMSenderC(AM_DISCO_RADIO);
  components new AMReceiverC(AM_DISCO_RADIO);

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Timer1 -> Timer1;
  App.yellowPin -> HplMsp430GeneralIOC.Port26; 
  App.greenPin -> HplMsp430GeneralIOC.Port23; 
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.Control -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
}
