#ifndef DISCOPROTOCOL_H
#define DISCOPROTOCOL_H

enum {
  AM_DISCO_RADIO = 6,
  TIMER_PERIOD_MILLI = 20,
  LEADING_EDGE_MILLI = 14,
  PRIME1 = 23,
  PRIME2 = 157,
  IDENTIFIER = 2, // 1 = send, 2 = receive 
};

typedef nx_struct DiscoRadioMsg {
  nx_uint16_t nodeid;
} DiscoRadioMsg;

#endif