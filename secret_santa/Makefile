OCAMLBUILD := ocamlbuild -classic-display -cflags "-g" -lflags "-g"
MAIN       := santa
EXEC       := santa
SUFFIX     := native

.PHONY: all clean test

all:
	$(OCAMLBUILD) $(MAIN).$(SUFFIX)
	ln -sf $(MAIN).$(SUFFIX) $(EXEC)

clean:
	rm -f *~ $(EXEC)
	$(OCAMLBUILD) -clean
