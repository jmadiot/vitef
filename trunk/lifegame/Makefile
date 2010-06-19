all:c opt

c:grid

opt:grid.opt

p=grid

${p}.opt:${p}.ml
	ocamlopt graphics.cmxa ${p}.ml -o ${p}.opt

${p}:${p}.ml
	ocamlc graphics.cma ${p}.ml -o ${p}

clean:
	rm -f ${p} ${p}.opt *.cmo *.cmx *.cmi *.o
