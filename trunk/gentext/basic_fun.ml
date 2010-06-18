#use "types.ml";;

let noms      = ref Node [] and
    verbes    = ref Node [] and
    articles  = ref Node [] and
    pronoms   = ref Node [] and
    adjectifs = ref Node []
;;

let nettoyer = fun s -> Str.global_replace (Str.regexp "_") " " s;;

let rec take n xs = match n with
	| 0     -> List.hd xs
	| n + 1 -> take n (List.tl xs)
;;

let rec add elem nom tree = match elem , tree with
	| []     , Leaf xs -> Leaf (nom :: xs)
	| n :: q , Node xs -> Node (add_list n q nom xs)
	| _      , _       -> Leaf []

and add_list n elem nom xs = match elem , xs with
	| 0     , []      -> [add elem nom (Node [])]
	| 0     , x :: xs -> (add elem nom x) :: xs
	| n + 1 , []      -> (Node []) :: (add_list n elem nom [])
	| n + 1 , x :: xs -> x :: (add_list n elem nom [])
;;

(*

TODO: From here

*)

let add_nom nom espece chp_lex genre =
    let nom     = nettoyer nom in
    let new_nom =
		{ espece  = espece;
		mot     = nom;
		chp_lex	= chp_lex; }
    in noms.(genre) <- (M new_nom)::(noms.(genre))
;;

let add_adjectif adjectif esp genre =
    let adjectif = nettoyer adjectif in
    let new_adj  =
		{ espece = esp;
		mot    = adjectif;
		chp_lex = -1; }
    in adjectifs.(genre) <- (M new_adj)::(adjectifs.(genre))
;;

let add_verbe verbe esp_suj esp_cibl chp_suj chp_cibl chp_lex =
    let verbe    = nettoyer verbe in
    let new_verb = {
		verbe    = verbe;
		esp_suj  = esp_suj;
		esp_cibl = esp_cibl;
		chp_suj  = chp_suj;
		chp_cibl = chp_cibl;
		chp_v    = chp_lex;
		   }
    in verbes := (V new_verb)::(!verbes)
;;

let add_article article genre =
    let article = nettoyer article in
    let new_art =
		{ espece  = -1;
		mot     = article;
		chp_lex = -1; }
    in articles.(genre) <- (M new_art)::(articles.(genre))
;;

let add_pronom pronom genre =
    let pronom  = nettoyer pronom in
    let new_pro =
		{ espece  = -1;
		mot     = pronom;
		chp_lex = -1; }
    in pronoms.(genre) <- (M new_pro)::(pronoms.(genre))
;;
