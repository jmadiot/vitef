#use "types.ml";;

let noms      = Array.make 2 [] and
    verbes    = ref [] and
    articles  = Array.make 2 [] and
    pronoms   = Array.make 3 [] and
    adjectifs = Array.make 2 []
;;

let nettoyer = fun s -> Str.global_replace (Str.regexp "_") " " s;;

let add_nom nom espece chp_lex genre =
    let nom     = nettoyer nom in
    let new_nom = {
	   	sorte   = Nom;
		espece  = espece;
		mot     = nom;
		chp_lex	= chp_lex;
          	  }
    in noms.(genre) <- (M new_nom)::(noms.(genre))
;;

let add_adjectif adjectif esp genre =
    let adjectif = nettoyer adjectif in
    let new_adj  = {
		sorte  = Adjectif;
		espece = esp;
		mot    = adjectif;
		chp_lex = -1;
		   }
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
    let new_art = {
		sorte   = Article;
		espece  = -1;
		mot     = article;
		chp_lex = -1;
		  }
    in articles.(genre) <- (M new_art)::(articles.(genre))
;;

let add_pronom pronom genre =
    let pronom  = nettoyer pronom in
    let new_pro = {
		sorte   = Pronom;
		espece  = -1;
		mot     = pronom;
		chp_lex = -1;
		  }
    in pronoms.(genre) <- (M new_pro)::(pronoms.(genre))
;;
