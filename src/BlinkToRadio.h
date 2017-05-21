// $Id: BlinkToRadio.h,v 1.4 2006/12/12 18:22:52 vlahan Exp $

#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 20,
  LEADING_EDGE_MILLI = 14,
  PRIME1 = 29,
  PRIME2 = 67,
  IDENTIFIER = 1, // 1 = send, 2 = receive
  
  //PRIME1 = 23,
  //PRIME2 = 157,
  //IDENTIFIER = 2, // 1 = send, 2 = receive
  };

typedef nx_struct BlinkToRadioMsg {
  nx_uint16_t nodeid;
} BlinkToRadioMsg;

#endif