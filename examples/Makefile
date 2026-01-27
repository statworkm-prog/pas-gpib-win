#ThomaS, 130126: to use the OS and ARCH variables in MinGW, wsl or other windows shell we need to set
#                them up manually. 
#                If you use a different console, add another ifeq
#                use this line to know what variables your current shell sets (they will often be empty too):
#                $(info OS: $(OS) ARCH: $(ARCH))
UNAME_S := $(shell uname -s)
#$(info UNAME_S = $(UNAME_S))

#MINGW
ifeq ($(findstring MINGW,$(UNAME_S)), MINGW)
  OS = Windows_NT
  ARCH = x86_64
endif

#wsl
#the shell name is just called "Linux"
ifeq ($(UNAME_S), Linux)
  OS = Linux
  ARCH = i386
endif

#$(info OS: $(OS) ARCH: $(ARCH))

#fpc, fpc options and programs
FPC = fpc
FPOPTS = -Fu../base -Fu../devcom -Fu../usb -Fu../pas-libusb/src -Fu../instruments -Fu../instruments/keithley -Fu../instruments/lecroy -Fu../instruments/rohdeschwarz -Fu../instruments/agilent
#in windows only this programm has been tested currently (and dont forget to change the ip-adress in the .pas file when using tcp)
PROGS =  testkeysighte3631xa
ifeq ($(OS), Windows_NT)
  FPOPTS += -Twin64
  # when using 64 bit, use the cross compiler ppcrossx64.exe instead of fpc.exe
  ifeq ($(ARCH), x86_64)
    #path to my ppcrossx64.exe in MinG64
    FPC = /c/FPC/3.2.2/bin/i386-win32/ppcrossx64.exe
    FPOPTS += -Fu"C:/FPC/3.2.2/units/x86_64-win64/" -Fu.. -Px86_64
  else
    FPC = /c/FPC/3.2.2/bin/i386-win32/fpc.exe
  endif
else
  FPC = fpc
  FPOPTS += -Fu../gpib
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
