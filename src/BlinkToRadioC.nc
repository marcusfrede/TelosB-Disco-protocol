#include <Timer.h>
#include "BlinkToRadio.h"
#include "printf.h"

module BlinkToRadioC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as Control;
}

implementation {

	uint16_t counter;
	uint16_t ledCounter;
    const uint16_t identifier = 1;
	
	message_t packet;
	message_t pkt;
	bool busy = FALSE;
	
	void initLeds() {
		if(identifier == 1) 
			call Leds.led0On();
		else 
			call Leds.led0Off();
		if(identifier == 2) 
			call Leds.led1On();
		else 
			call Leds.led1Off();
		call Leds.led2Off();
	}
	

	event void Boot.booted() {
	 	initLeds();
		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
	}

	event void Control.startDone(error_t err) {
		if(err == SUCCESS) {
		}
		else {
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
	}

	event void Control.stopDone(error_t err) {
	}

	event void Timer0.fired() {
		counter++;
		if( !busy && counter % COPRIME == 0) {
			call Control.start();		
		}
		if(!busy && counter % COPRIME == 1){
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg* )(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
			if(btrpkt == NULL) {return;}
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->counter = ++ledCounter;
	
			if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
		if( !busy && counter % COPRIME == 2) {
			call Control.stop();
		}
	}

	event void AMSend.sendDone(message_t * msg, error_t err) {
		if(&pkt == msg) {
			TestSerialMsg* rcm = (TestSerialMsg*) call Packet.getPayload(&packet, sizeof(TestSerialMsg));
			if (rcm == NULL) {return;}
			rcm->counter = ledCounter;
			busy = FALSE;		
	
			if(call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(TestSerialMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
	}

	event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len) {
		if(len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg * btrpkt = (BlinkToRadioMsg *) payload;
			printf("Message received from %u\n", btrpkt);
			printfflush();
		}
		return msg;
	}
}