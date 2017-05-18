#include <Timer.h>
#include "BlinkToRadio.h"

module BlinkToRadioC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as AMControl;
}
implementation {

	uint16_t counter;
	uint16_t ledCounter;
	
	message_t packet;
	message_t pkt;
	bool busy = FALSE;

	void setLeds(uint16_t val) {
		if(val & 0x01) 
			call Leds.led0On();
		else 
			call Leds.led0Off();
		if(val & 0x02) 
			call Leds.led1On();
		else 
			call Leds.led1Off();
		if(val & 0x04) 
			call Leds.led2On();
		else 
			call Leds.led2Off();
	}

	event void Boot.booted() {
		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		//call AMControl.start();
	}

	event void AMControl.startDone(error_t err) {
		if(err == SUCCESS) {
			//call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		else {
			//call AMControl.start();
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event void Timer0.fired() {
		counter++;
		if( !busy && counter % COPRIME == 0) {
			call AMControl.start();		
		}
		if( !busy && counter % COPRIME == 1) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg* )(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
			if(btrpkt == NULL) {
				return;
			}
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->counter = ++ledCounter;
			if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
		if( !busy && counter % COPRIME == 2) {
			call AMControl.stop();
		}
	}

	event void AMSend.sendDone(message_t * msg, error_t err) {
		if(&pkt == msg) {
			busy = FALSE;		
			test_serial_msg_t* rcm = (test_serial_msg_t*) call Packet.getPayload(&packet, sizeof(test_serial_msg_t));
			//if (rcm == NULL) {return;}
			//rcm->counter = ledCounter;
			//call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(test_serial_msg_t));	
		}
	}

	event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len) {
		if(len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg * btrpkt = (BlinkToRadioMsg *) payload;
			setLeds(btrpkt->counter);
		}
		return msg;
	}
}