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

#Adjust Directories
DIRS = base usb devcom instruments examples
ifneq ($(OS), Windows_NT)
  DIRS += gpib
endif
#Furthermore, the files devcomgpib, testkeithley2010 and testrohdeschwarzfse 
#are empty in windows. I looked into excluding these files from compilation,
#but the amount of changes I would have to make is far greater than simply adjusting the files

#Adjust Pascal-flags
FPCFLAGS = ""
ifeq ($(OS), Windows_NT)
  FPCFLAGS += -P x86_64 -T win64 -Fu"C:/FPC/3.2.2/units/x86_64-win64"
endif

all:
	-for dir in $(DIRS) ; do $(MAKE) -C $$dir $@ FPCFLAGS="$(FPCFLAGS)" ; done

clean:
	-for dir in $(DIRS) ; do $(MAKE) -C $$dir $@ ; done
	rm -f *~
