
#UNAME_S := $(shell uname -s)
#$(info UNAME_S = $(UNAME_S))

#MINGW
#ifeq ($(findstring MINGW,$(UNAME_S)), MINGW)
#  OS = Windows_NT
#  ARCH = x86_64
#endif

#wsl
#the shell name is just called "Linux"
#ifeq ($(UNAME_S), Linux)
#  OS = Linux
#  ARCH = i386
#endif

$(info OS: $(OS) ARCH: $(ARCH))

#fpc, fpc options and programs
FPC = fpc
FPOPTS = -Fu../base -Fu../devcom -Fu../usb -Fu../pas-libusb/src -Fu../instruments -Fu../instruments/keithley -Fu../instruments/lecroy -Fu../instruments/rohdeschwarz -Fu../instruments/agilent
#in windows only this programm has been tested (and dont forget to change the ip-adress in the .pas file when using tcp):
PROGS =  testkeysighte3631xa

ifeq ($(OS), Windows_NT)
  ifeq ($(ARCH), x86_64)
    FPOPTS +=  -Fu.. -Px86_64 -Twin64
  endif
else
  FPOPTS += -Fu../gpib
#in linux these other programs should also work (needs testing):
  PROGS += testkeithley2010 testrohdeschwarzfse fpgacurrentmeasurement testlecroywavejet3xx testusbtmc testagilent34410a testagilentmsox3000a agilentmsox3000a-serial serialparse agilentmsox3000a-screenshot
endif

#programs

all: $(PROGS)

testkeysighte3631xa: testkeysighte3631xa.pas
	-$(FPC) $(FPOPTS) $<

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
