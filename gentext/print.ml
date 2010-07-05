#use "types.ml";;
#use "char.ml";;

let voyelles = ['a';'e';'i';'o';'u';'y';'h';"é".[0];"è".[0]];;

let is_voyelle x =
    let rec aux = function
	| []     -> false
	| t :: q -> x = t || aux q
    in aux voyelles

let rec_print ls =
    let rec aux flag = function
    | []     -> ()
    | [ t ]  -> if flag then print_string(" et "^t) else print_string (" "^t)
    | t :: q ->
		begin
		(if flag then print_string(", "^t) else print_string (" "^t));
		aux true q
		end
    in aux false ls


let print_sujet flag = function
(* Le sujet est soit un pronom *)
	| Pr (pronom) ->
		begin
		let () = pronom.[0] <- Char.uppercase pronom.[0]
		in  print_string (pronom)
		end
(* soit un groupe nominal *)
	| G_n gn       ->
		begin match gn.article, gn.nom, gn.adjectifs with
		| art, n, lst ->
			begin
			if is_voyelle (n.[0])
			then 	(if flag
                        	then (print_string ("L'"^n); rec_print lst)
		                else (print_string ("l'"^n); rec_print lst))
			else let a = String.copy art in
			(if flag then  a.[0] <- Char.uppercase a.[0]);
                        print_string (a^" "^n); rec_print lst
			end
		end

let print_proposition b = function
	| subj, v, gn ->
		print_sujet b subj;
		print_string (" "^v^" ");
		print_sujet false (G_n gn);

let print_relative = function
	| subj,  v, gn ->
		print_string v.verbe;
		print_string " ";
		print_sujet false (G_n gn);

let rec print_texte text =
	let rec aux_print b flag = function
		| []     -> ()
		| t :: q ->
			(begin
			match t with
		    		| Prop p         -> print_proposition b p
     	    			| Conj []        -> ()
		    	   	| Conj [t]       -> print_string " et "; aux_print b false [t]
    	    			| Conj (t :: q)  ->
					begin
					let () = if not flag then print_string ", " in
					let () = aux_print b false [t]              in
					aux_print false false [Conj q]
					end
				| Relat (ph , p) ->
					begin
					let () = aux_print flag b [ph] in
					let () = print_string " qui "  in
					print_relative p
					end
		  	end ; aux_print false true q)
	in match text with
		| []     -> ()
		| t :: q ->
			begin
			let () = aux_print true true [t] in
			let () =  print_string ". "      in
			print_texte q
			end

