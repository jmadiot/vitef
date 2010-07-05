#use "basic_fun.ml";;

add_nom "pêcheur" 0 0 0;
add_nom "poisson" 1 0 0;
add_nom "goujon" 1 0 0;
add_nom "filet" 2 0 0;
add_nom "pêcheuse" 0 0 1;
add_nom "truite" 1 0 1;
add_nom "canne_à_pêche" 2 0 1;
add_article "le" 0;
add_article "la" 1;
add_article "un" 0;
add_article "une" 1;
add_pronom "je" 0;
add_pronom "je" 1;
add_pronom "il" 0;
add_pronom "elle" 1;
add_verbe "pêcher" 0 1 0 0 0;
add_verbe "vendre" 0 1 0 0 0;
add_verbe "capturer" 0 1 0 0 0;
add_verbe "mordre" 1 0 0 0 0;
(*
print_dico " " (!verbes); print_newline (); print_newline();
print_dico " " (!noms);;
*)
