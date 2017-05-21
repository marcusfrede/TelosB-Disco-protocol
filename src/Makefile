COMPONENT=BlinkToRadioAppC
BUILD_EXTRA_DEPS += BlinkToRadio.class
CLEAN_EXTRA = *.class TestSerialMsg.java

CFLAGS += -I$(TOSDIR)/lib/printf


BlinkToRadio.class: $(wildcard *.java) TestSerialMsg.java
	javac -target 1.4 -source 1.4 *.java

TestSerialMsg.java:
	mig java -target=null $(CFLAGS) -java-classname=TestSerialMsg BlinkToRadio.h TestSerialMsg -o $@
include $(MAKERULES)
