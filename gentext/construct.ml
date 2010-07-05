#use "fill.ml";;

(** À certains moments, il faudra faire des choix
aléatoires. On regardera bien entendu le nombre de fils
non vides **)

let () = Random.self_init ()

(* proper_* : fonctions ne tenant pas compte des
branches vides *)

(* tree -> nat *)
let proper_length xs =
    let rec aux accu = function
		| []		     -> accu
		| (Node []) :: q -> aux accu q
		| (Leaf []) :: q -> aux accu q
		| _ :: q         -> aux (accu + 1) q
	in aux 0 xs

(* nat -> tree -> tree *)
let rec proper_lookup n xs = match n , xs with
	| _ , []             -> failwith "Chemin trop long - proper_lookup fail"
	| n , (Node []) :: q -> proper_lookup n q
	| n , (Leaf []) :: q -> proper_lookup n q
	| 0 , t :: _         -> t
	| n , _ :: q         -> proper_lookup (n - 1) q

(* nat -> tree -> nat *)
let rec proper_index n xs = match n , xs with
	| _ , []             -> 0
	| n , (Node []) :: q -> 1 + (proper_index n q)
	| n , (Leaf []) :: q -> 1 + (proper_index n q)
	| 0 , _ :: q         -> 0
	| n , _ :: q         -> 1 + (proper_index (n - 1) q)

(* Prendre un fils non vide au hasard *)
let rand_tree xs =
	proper_lookup (Random.int (proper_length xs)) xs

let rand_list xs =
	lookup (Random.int (List.length xs)) xs

(* Selectionner un élément en suivant un chemin totalement
ou partiellement défini : type choice = | Rand | Int of int.
On ira quoi qu'il arrive jusqu'aux feuilles en complétant par
des Rand.*)
let rec select_path tree path = match path , tree with
	| []           , Leaf ts -> rand_list ts
	| []           , Node ts -> select_path (rand_tree ts) []
	| [ Rand ]     , Leaf ts -> rand_list ts
	| [ Int n ]    , Leaf ts -> lookup n ts
	| Rand :: q    , Node ts -> select_path (rand_tree ts) q
	| (Int n) :: q , Node ts -> select_path (lookup n ts) q
	| _            , _       -> "Error : select_path default"

(* Récupérer les fils d'un noeud *)

let elim_node = function
	| Node xs -> xs
	| _	      ->  failwith "Error : elim_node failure"

let elim_leaf = function
	| Leaf xs -> xs
	| _	      ->  failwith "Error : elim_leaf failure"

(* Construire une proposition à partir de rien. Certainement à modifier
pour avoir des textes cohérents (chp lexial par exemple) *)

(*TODO: Fix this *)
let construct_adjlist genre esp = ["pipo"]

let construct_gn esp chp =
	let genre 	= Random.int 2 						in
	let article	= select_path (!articles) [ Int genre ]			in
	let nom		= select_path (!noms) [ Int genre ; Int esp ; Int chp ]	in
	let adjlist = construct_adjlist genre esp				in
	G_n {
		article 	= article;
		adjectifs 	= adjlist;
		nom			= nom;
		}

let construct_sujet esp chp = match Random.int 2 with
	| 0 ->
		begin
		let genre = Random.int 3 in
		Pr (select_path (!pronoms) [Int genre])
		end
    | _ ->
		construct_gn esp chp

let construct_proposition chp_lex =
		let tmp			= elim_node (!verbes)					in
		let esp_sujet 		= proper_index (Random.int (proper_length tmp))	tmp	in
		let tmp			= elim_node (lookup esp_sujet tmp)			in
		let esp_cible		= proper_index (Random.int (proper_length tmp))	tmp	in
		let tmp			= elim_node (lookup esp_cible tmp)			in
		let chp_sujet		= proper_index (Random.int (proper_length tmp)) tmp	in
		let tmp         	= elim_node (lookup chp_sujet tmp)                 	in
		let chp_cible		= proper_index (Random.int (proper_length tmp)) tmp	in
		let tmp			= elim_node (lookup chp_cible tmp)			in
		let verbe		= rand_list (elim_leaf (lookup chp_lex tmp))		in
		let sujet		= construct_sujet esp_sujet chp_sujet			in
		let cible		= construct_gn esp_cible chp_cible			in
		sujet , verbe , cible

(*TODO: From here*)

(*
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
*)
