
#UNAME_S := $(shell uname -s)
#$(info OS: $(OS) ARCH: $(ARCH))
#$(info UNAME_S = $(UNAME_S))

#find your shell and adjust your OS and ARCH accordingly:

#MINGW64
#ifeq ($(findstring MINGW,$(UNAME_S)), MINGW)
#  OS = Windows_NT
#  ARCH = x86_64
#endif

#wsl
#in wsl the shell name is just "Linux"
#ifeq ($(UNAME_S), Linux)
#  OS = Linux
#  ARCH = i386
#endif

$(info OS: $(OS) ARCH: $(ARCH))

# Define all the directories
DIRS = base usb devcom instruments examples
ifneq ($(OS), Windows_NT)
  DIRS += gpib
endif

# Change the path to your fpc compiler here if necessary:
FPC = fpc

# Set compiler folder and compiler flags
FPCFLAGS = ""
ifeq ($(OS), Windows_NT)
  ifeq ($(ARCH), x86_64)
    FPCFLAGS += -Twin64 -Px86_64
  endif
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
