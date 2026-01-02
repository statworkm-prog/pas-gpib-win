DIRS = base gpib usb devcom instruments examples
ifeq ($(OS), Windows_NT)
	FPCFLAGS = -P x86_64 -T win64 -Fu"C:/FPC/3.2.2/units/x86_64-win64"
else 
	FPCFLAGS = ""
endif
all:
	-for dir in $(DIRS) ; do $(MAKE) -C $$dir $@ FPCFLAGS="$(FPCFLAGS)" ; done

clean:
	-for dir in $(DIRS) ; do $(MAKE) -C $$dir $@ ; done
	rm -f *~
