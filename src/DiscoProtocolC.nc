#include <Timer.h>
#include "DiscoProtocol.h"
#include "printf.h"

module DiscoProtocolC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface HplMsp430GeneralIO as yellowPin;
	uses interface HplMsp430GeneralIO as greenPin;
	uses interface Receive;
	uses interface SplitControl as Control;
}

implementation {
	uint16_t counter;
	uint16_t diffCounter;
	uint16_t ledCounter;
	uint16_t termCount;
  	uint16_t i;

	message_t packet;
	message_t pkt;
	bool busy = FALSE;
	
	void initLeds() {
		if(IDENTIFIER == 1) 
			call Leds.led0On();
		else 
			call Leds.led0Off();
		if(IDENTIFIER == 2) 
			call Leds.led1On();
		else 
			call Leds.led1Off();
		call Leds.led2Off();
	}
	

	event void Boot.booted() {
		initLeds();
		call yellowPin.makeOutput();
		call greenPin.makeOutput();

		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
	}	
	
	event void Timer0.fired() {
		counter++;
		diffCounter++;

		if( !busy && ((counter % PRIME1 == 0) || (counter % PRIME2 == 0))) {
			call Control.start();		
		}
		
		if (((counter % PRIME1 == 1) || (counter % PRIME2 == 1))) {
			call Control.stop();
			call Timer1.stop();
			busy = FALSE;
		}
		
		if(termCount >= 400){
			call Timer0.stop();
			call Timer1.stop();
			printf("--Done--\n");
		}
		
		printfflush();
	}

	void sendMessage() {
		DiscoRadioMsg* btrpkt = (DiscoRadioMsg* )(call Packet.getPayload(&pkt, sizeof(DiscoRadioMsg)));
		btrpkt->nodeid = TOS_NODE_ID;

		if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DiscoRadioMsg)) == SUCCESS) {				
			printf("sendMessage - send is success\n");	
			busy = TRUE;
			call Timer1.startOneShot(LEADING_EDGE_MILLI);
		} else {
			printf("sendMessage - failed\n");
		}
	}
	
	event void Timer1.fired() {
		sendMessage();
	}

	event void Control.startDone(error_t err) {
		if(err != SUCCESS) {
			return;
		}

		call yellowPin.set();
		
		if (IDENTIFIER == 1) {
			call Timer1.startOneShot(LEADING_EDGE_MILLI);
			sendMessage();
		}
	}

	event void Control.stopDone(error_t err) {
		call yellowPin.clr();

		if (IDENTIFIER == 1) {
			printf("------\n");
		}
	}

	event void AMSend.sendDone(message_t * msg, error_t err) {
		if(&pkt == msg) {
			busy = FALSE;
		}
	}

	event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len) {
		if(len == sizeof(DiscoRadioMsg)) {
			call greenPin.set();

			termCount++;
			printf("%u-%u\n", termCount ,diffCounter * TIMER_PERIOD_MILLI);
			diffCounter = 0;
			call Control.stop();
				call greenPin.clr();
			printfflush();
		} else {
			printf("Message failed receive\n");
			printfflush();
		}
		return msg;
	}
}