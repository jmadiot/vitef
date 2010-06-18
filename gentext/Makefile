all:parse fill.ml

parse:parse.c
	gcc -Wall parse.c -o parse

fill.ml:parse dico.txt
	./parse < dico.txt > fill.ml

spam:main.ml fill.ml
	ocaml str.cma main.ml

