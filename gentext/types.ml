type dico =
	| Leaf of string list
	| Node of dico list

type choice =
	| Int of int
	| Rand

type groupe_nominal = {
	article   : string;
	adjectifs : string list;
	nom	  : string;
}

type sujet = Pr of string | G_n of groupe_nominal

type proposition = sujet * string * groupe_nominal

type phrase =
	| Prop 	of proposition
	| Conj 	of phrase list
	| Relat of phrase * proposition

type texte = phrase list
