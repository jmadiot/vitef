#use "types.ml";;

(* Nos dictionnaires : plus ou moins des arbres de décision *)

let noms      = ref (Node []) and
    verbes    = ref (Node []) and
    articles  = ref (Node []) and
    pronoms   = ref (Node []) and
    adjectifs = ref (Node [])

(* Nettoyage des chaînes de caractères *)

let nettoyer = fun s -> Str.global_replace (Str.regexp "_") " " s

(** Remplissage des dictionnaires : insertion dans un arbre de
décision en suivant les indications données par une liste de choix.
Chaque choix est un naturel indiquant le sous-arbre fils **)

let rec lookup n xs = match n with
	| 0 -> List.hd xs
	| n -> lookup (n - 1) (List.tl xs)

let rec insert_tree path value tree = match path , tree with
	| []     , Leaf xs -> Leaf (value :: xs)
	| [ n ]  , Node xs -> Node (insert_list_leaf n value xs)
	| n :: q , Node xs -> Node (insert_list_node n q value xs)
	| _      , _       -> Leaf []

and insert_list_leaf index value xs = match index , xs with
	| 0 , []              -> [Leaf [value]]
	| 0 , (Leaf x) :: xs' -> (Leaf (value :: x)) :: xs'
	| 0 , (Node _) :: _   -> []
	| n , []              -> (Leaf []) :: (insert_list_leaf (n - 1) value [])
	| n , x :: xs'        -> x :: (insert_list_leaf (n - 1) value xs')

and insert_list_node index path value xs = match index , xs with
	| 0 , []      -> [insert_tree path value (Node [])]
	| 0 , x :: xs' -> (insert_tree path value x) :: xs'
	| n , []      -> (Node []) :: (insert_list_node (n - 1) path value [])
	| n , x :: xs' -> x :: (insert_list_node (n - 1) path value xs')

(** Spécifications : chaque arbre (profondeur, nombre de fils
à chaque "étage", etc.) et les fonctions inserent donc les
bons mots dans les bons arbres **)

let add_nom nom espece chp_lex genre =
    let nom   = nettoyer nom in
        noms := insert_tree [genre ; espece ; chp_lex] nom (!noms)

let add_adjectif adjectif esp genre =
    let adjectif   = nettoyer adjectif in
        adjectifs := insert_tree [genre ; esp] adjectif (!adjectifs)

let add_verbe verbe esp_suj esp_cibl chp_suj chp_cibl chp_lex =
    let verbe   = nettoyer verbe in
        verbes := insert_tree [esp_suj ; esp_cibl ; chp_lex ; chp_suj ; chp_cibl] verbe (!verbes)

let add_article article genre =
    let article   = nettoyer article in
    	articles := insert_tree [genre] article (!articles)

let add_pronom pronom genre =
    let pronom   = nettoyer pronom in
    	pronoms := insert_tree [genre] pronom (!pronoms)

let rec print_list str = function
	| []     -> ()
	| t :: q -> print_newline (); print_string (str^t^" :: "); print_list str q

let rec print_dicolist str = function
	| [] 	  -> ()
	| t :: ts -> print_newline (); print_dico str t; print_dicolist str ts

and print_dico str = function
	| Node ts -> print_string str ; print_string "Node"; print_dicolist ("-"^str) ts
	| Leaf ts -> print_string str ; print_string "Leaf"; print_list ("-"^str) ts
