#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 20,
  LEADING_EDGE_MILLI = 14,
  PRIME1 = 23,
  PRIME2 = 157,
  IDENTIFIER = 2, // 1 = send, 2 = receive
  
  //PRIME1 = 23,
  //PRIME2 = 157,
  //IDENTIFIER = 2, // 1 = send, 2 = receive
  };

typedef nx_struct BlinkToRadioMsg {
  nx_uint16_t nodeid;
} BlinkToRadioMsg;

#endif