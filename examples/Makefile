#ThomaS, 130126: to use the OS and ARCH variables in MinGW we need to set
#                them up manually first as they wont get setup automatically... 
#$(info OS: $(OS) ARCH: $(ARCH))
UNAME_S := $(shell uname -s)
# e.g. returns "MINGW64_NT-10.0-26200"
UNAME_LIST := $(subst _, ,$(UNAME_S))
OS_PREFIX := $(word 1,$(UNAME_LIST))
ifeq ($(OS_PREFIX), MINGW64)
  export OS= Windows_NT
  export ARCH = x86_64
endif

#fpc options
FPC = fpc
FPOPTS = -Fu../base -Fu../devcom -Fu../usb -Fu../pas-libusb/src -Fu../instruments -Fu../instruments/keithley -Fu../instruments/lecroy -Fu../instruments/rohdeschwarz -Fu../instruments/agilent
ifeq ($(OS), Windows_NT)
    FPC_OPTS += -Fu.. -Px86_64 -Twin64
else 
    FPC_OPTS += -Fu../gpib
endif

#programs
PROGS = fpgacurrentmeasurement testlecroywavejet3xx testusbtmc testagilent34410a testagilentmsox3000a agilentmsox3000a-serial serialparse agilentmsox3000a-screenshot

ifeq ($(OS), Windows_NT)
    PROGS += testkeithley2010 testrohdeschwarzfse
endif

all: $(PROGS)

fpgacurrentmeasurement: fpgacurrentmeasurement.pas
	-$(FPC) $(FPOPTS) $<

testkeithley2010: testkeithley2010.pas
	-$(FPC) $(FPOPTS) $<

testlecroywavejet3xx: testlecroywavejet3xx.pas
	$(FPC) $(FPOPTS) $<

testrohdeschwarzfse: testrohdeschwarzfse.pas
	-$(FPC) $(FPOPTS) $<

testusbtmc: testusbtmc.pas
	$(FPC) $(FPOPTS) $<

testagilent34410a: testagilent34410a.pas
	$(FPC) $(FPOPTS) $<

testagilentmsox3000a: testagilentmsox3000a.pas
	$(FPC) $(FPOPTS) $<

agilentmsox3000a-serial: agilentmsox3000a-serial.pas
	$(FPC) $(FPOPTS) $<

serialparse: serialparse.lpr serialparsei2c.pas serial-i2c-lex.pas serial-i2c-parser.pas
	$(FPC) $(FPOPTS) $<

serial-i2c-parser.pas: serial-i2c-parser.y
	pyacc serial-i2c-parser.y

serial-i2c-lex.pas: serial-i2c-lex.l serial-i2c-parser.pas
	plex serial-i2c-lex.l

agilentmsox3000a-screenshot: agilentmsox3000a-screenshot.lpr
	$(FPC) $(FPOPTS) $<

clean:
	rm -f $(PROGS) *.o *.ppu *~ *.compiled *.or wj-*.png *-parser.pas *-lex.pas
