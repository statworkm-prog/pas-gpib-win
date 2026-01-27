
UNAME_S := $(shell uname -s)
#$(info OS: $(OS) ARCH: $(ARCH))
#$(info UNAME_S = $(UNAME_S))

#find your shell and adjust your OS and ARCH accordingly

#MINGW64 (should then also work using cmd)
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

# Define all the directories
DIRS = base usb devcom instruments examples
ifneq ($(OS), Windows_NT)
  DIRS += gpib
endif


# Set compiler folder and compiler flags
FPCFLAGS = ""
ifeq ($(OS), Windows_NT)
  FPCFLAGS += -Twin64
  # when using 64 bit, use the cross compiler ppcrossx64.exe instead of fpc.exe
  ifeq ($(ARCH), x86_64)
    #path to ppcrossx64.exe in MinG64
    #change it if you have a different path
    FPC = /c/FPC/3.2.2/bin/i386-win32/ppcrossx64.exe
    FPCFLAGS += -Px86_64 -Fu"C:/FPC/3.2.2/units/x86_64-win64"
  else
    FPC = /c/FPC/3.2.2/bin/i386-win32/fpc.exe
  endif
else
  FPC = fpc
endif

all:
	@for dir in $(DIRS) ; do \
		$(MAKE) -C $$dir $@ FPC="$(FPC)" FPCFLAGS="$(FPCFLAGS)"; \
	done

clean:
	@for dir in $(DIRS) ; do \
		$(MAKE) -C $$dir clean ; \
	done
	rm -f *~
