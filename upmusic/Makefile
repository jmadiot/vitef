OCAMLBUILD := ocamlbuild -classic-display -use-menhir -cflags "-g" -lflags "-g"
MAIN       := main
EXEC       := toy
SUFFIX     := native

all:
	$(OCAMLBUILD) $(INCLUDE) $(MAIN).$(SUFFIX)
	ln -sf $(MAIN).$(SUFFIX) $(EXEC)

todos:
	grep "TODO" -R . > TODOS
	cat TODOS

clean:
	rm -f *~ $(EXEC) lexer.mll TODOS
	$(OCAMLBUILD) -clean
