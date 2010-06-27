type mot = string

type dico =
	| Leaf of mot list
	| Node of dico list

type choice =
	| Int of int
	| Rand

type groupe_nominal = {
	article   : mot;
	adjectifs : mot list;
	nom		  : mot;
}

type sujet = Pr of mot | G_n of groupe_nominal

type proposition = sujet * mot * groupe_nominal

type phrase =
	| Prop 	of proposition
	| Conj 	of phrase list
	| Relat of phrase * proposition

type texte = phrase list
