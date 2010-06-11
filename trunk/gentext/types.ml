type sorte = Adjectif | Article | Nom | Pronom
;;

type vocable = {
	sorte   : sorte;
	mot     : string;
	espece  : int;
	chp_lex : int;
};;

type verbe = {
	verbe    : string;
	esp_suj  : int;
	esp_cibl : int;
	chp_suj  : int;
	chp_cibl : int;
	chp_v    : int;
};;

type mot = V of verbe | M of vocable;;

type groupe_nominal = {
	article   : mot;
	adjectifs : mot list;
	nom	  : mot;
};;

type sujet = Pr of mot | G_n of groupe_nominal
;;

type proposition = sujet * mot * groupe_nominal
;;

type phrase =
	| Prop of proposition
	| Conj of phrase list
	| Relat of phrase * proposition
;;

type texte = phrase list
;;
