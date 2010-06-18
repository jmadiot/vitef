#use "fill.ml";;
#use "print.ml";;

Random.self_init();;

let rec rand_champ = fun () -> let n = Random.int nbre_chp in
    match borne_verbes.(n) with
	| 0 -> rand_champ ()
	| _ -> n
;;

let test t chp espece = match t with
	| V v -> v.chp_v = chp
	| M m -> match m.sorte with
		| Nom      -> m.espece = espece && (Random.int 5 = 0 || m.chp_lex = chp)
		| Adjectif -> m.espece = espece
		| _        -> true
;;

let select lst chp esp nbre =
    let rec aux flag ls nb accu = match flag,nb,ls with
	| 0, 0, _    -> accu
	| _, _, []   -> accu
	| 1, 0, t::q -> if test t chp esp
			then t
			else aux 1 q 0 accu
	| f, n, t::q -> if test t chp esp
			then aux 0 q (n-1) t
			else aux f q n accu
    in aux 1 lst nbre (List.hd lst)
;;

let rec select_adjectifs genre espece =
    if Random.int 5 = 0 && borne_adjectifs.(genre).(espece) <> 0
    then let choix = Random.int (borne_adjectifs.(genre).(espece) + 1)  in
	(select (adjectifs.(genre)) (-1) espece choix)::(select_adjectifs genre espece)
    else []
;;

let select_gn chp esp_suj genre =
    let choix = Random.int (List.length (articles.(genre)) + 1)     in
    let art   = select (articles.(genre)) (-1) (-1) choix           in
    let choix = Random.int (borne_noms.(genre).(chp).(esp_suj) + 1) in
    let nom   = select (noms.(genre)) chp esp_suj choix             in
    let adj_l = select_adjectifs genre esp_suj                      in
	G_n ({ article = art; adjectifs = adj_l; nom = nom })
;;

let select_sujet chp esp_suj =
    if Random.int 2 = 0
    then 
	let genre = Random.int 3 in
	let choix = Random.int (List.length (pronoms.(genre)) + 1) in
	Pr (select (pronoms.(genre)) (-1) (-1) choix)
    else
	let genre = Random.int 2 in select_gn chp esp_suj genre
;;

let rec construct_proposition chp =
    let choix = Random.int (borne_verbes.(chp) + 1) in
    let verb  = match select (!verbes) chp (-1) choix with
		| V v -> v
		| _   -> failwith "Problème de type. Voir construct.ml, ligne 60."
    in
    let genre = Random.int 2 in
    let sujet = select_sujet (verb.chp_suj) (verb.esp_suj) in
    let cible = select_gn (verb.chp_cibl) (verb.esp_cibl) genre in
    match cible with
	| G_n c -> Prop (sujet, V verb, c)
	| _     -> failwith "Problème de type. Voir construct.ml, ligne 67."

and construct_relative chp =
    match construct_proposition chp with
	| Prop p -> Relat (construct_phrase chp, p)
	| _      -> failwith "Problème de type. Voir construct.ml, ligne 73."

and construct_conj chp nbre accu =
    if nbre > 0 || Random.int 2 = 0
    then construct_conj chp (max (nbre - 1) 0) ((construct_proposition chp)::accu)
    else Conj accu

and construct_phrase chp = 
    match Random.int 5 with
	| n when n < 3 -> construct_proposition chp
	| n when n < 4 -> construct_relative chp
	| _            -> construct_conj chp 2 []
;;

let rec take l = function
    | 0 -> List.hd l
    | n -> take (List.tl l) (n-1)
;;

let construct_texte proba =
    let chp = rand_champ () in
    let rec aux_texte accu tours =
	if tours > 0 || Random.int 100 >= proba
	then aux_texte ((construct_phrase chp)::accu) (max (tours - 1) 0)
	else accu
    in aux_texte [] 5
;;

let construct_page borne =
    let paragraphes = Random.int borne in
    for i = 0 to paragraphes do
	print_texte (construct_texte 50);
    	print_newline();
    done
;;
