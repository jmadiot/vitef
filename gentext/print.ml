#use "types.ml";;
#use "char.ml";;

let voyelles = ['a';'e';'i';'o';'u';'y';'h';"é".[0];"è".[0]];;

let is_voyelle x =
    let rec aux = function
	| [] -> false
	| t::q -> x = t || aux q
    in aux voyelles
;;

let rec_print ls =
    let rec aux flag = function
    | []       -> ()
    | (V _)::q -> failwith "Ouais on y croit !"
    | [M t]    -> if flag then print_string(" et "^(t.mot)) else print_string (" "^t.mot)
    | (M t)::q ->
		begin
		(if flag then print_string(", "^(t.mot)) else print_string (" "^t.mot));
	        rec_print_aux true q
		end
    in aux false ls
;;

let print_sujet flag = function
    | Pr (M pronom) -> pronom.mot.[0] <- Char.uppercase pronom.mot.[0]; print_string (pronom.mot)
    | G_n gn        -> (match gn.article, gn.nom, gn.adjectifs with
	| M art, M n, lst -> if is_voyelle ((n.mot).[0])
                	       then
				   (
				   if flag 
			           then (print_string ("L'"^(n.mot)); rec_print lst)
                  	           else (print_string ("l'"^(n.mot)); rec_print lst)
                  	           )
			       else let a = String.copy art.mot in
                      	           (if flag then  a.[0] <- Char.uppercase a.[0]);
                		   print_string (a^" "^(n.mot)); rec_print lst
	| _ -> failwith "Oué c'est ça oué !")
    | _ -> failwith "Oué c'est ça oué !"
;;

let print_proposition b = function
    | subj, V v, gn ->
		print_sujet b subj;
		print_string (" "^(v.verbe)^" ");
		print_sujet false (G_n gn);
    | _ -> failwith "Oué c'est ça oué !"
;;

let print_relative = function
    | subj, V v, gn ->
		print_string v.verbe;
		print_string " ";
		print_sujet false (G_n gn);
    | _ -> failwith "On y croit !"
;;

let rec print_texte text =
    let rec aux_print b flag = function
	| []   -> ()
	| t::q -> (match t with
    		| Prop p       -> print_proposition b p
     	    	| Conj []      -> ()
    	   	| Conj [t]     -> print_string " et "; aux_print b false [t]
    	    	| Conj (t::q)  -> (if not flag then print_string ", "); aux_print b false [t];
				aux_print false false [Conj q]
    	    	| Relat (ph,p) -> aux_print flag b [ph]; print_string " qui "; print_relative p
	  ); aux_print false true q
in match text with
    | [] -> ()
    | t::q -> aux_print true true [t] ; print_string ". " ; print_texte q
;;
