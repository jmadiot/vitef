#MLS:=fill.ml $(shell find * -name '*.ml' | grep -v ^main.ml$) main.ml
MLS:=types.ml basic_fun.ml construct.ml fill.ml print.ml
CMOS:=$(MLS:.ml=.cmo)
FLAGS:=str.cma
OPTFLAGS:=str.cmxa

all:main

parse:parse.c
	gcc -Wall parse.c -o parse

fill.ml:parse dico.txt
	./parse < dico.txt > fill.ml

main:$(CMOS)
	ocamlc $(FLAGS) $(CMOS) main.ml -o main

spam:main
	./main

clean:
	rm -f parse fill.ml .depend *.cm[ixo] main fill.ml

.depend:$(MLS)
	ocamldep $(MLS) > .depend

include .depend

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	ocamlc $(FLAGS) $(CMOS) -c $<

.mli.cmi:
	ocamlc $(FLAGS) -c $<

#.ml.cmx:
#	ocamlopt $(CMXS) $(OPTFLAGS) -c $<

