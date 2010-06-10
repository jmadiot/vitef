(**
	Calcule toutes les formes possibles avec un nombre donné de carrés.
	L'ensemble peut être invariant par rotation comme par rotation et symétrie.
**)
(*
	exemple :
		invariant par rotation et symétrie :
			1 -> 1
			2 -> 1
			3 -> 2
			4 -> 5
			5 -> 12 (pentomino)
			6 -> 35
			7 -> 108
			8 -> 369
			9 -> 1285
			10 -> 4655
			11 -> 17073
			(A000105 on )
			
		invariants par rotation :
			1 -> 1
			2 -> 1
			3 -> 2
			4 -> 7 (tetris)
			5 -> 18
			6 -> 60
			7 -> 196
			8 -> 704
			9 -> 2500
			10 -> 9189
			11 -> 33896
			(A000988)
*)

open Graphics;;



(** Shapes **)

type 'a v = { x:'a; y:'a };; let v x y = {x=x;y=y};;

type shape = int v list;;



(** Display **)

type grid = {
	bot : int v;
	width : int;
	border : int;
	foreground : color;
	background : color;
};;

let print_shape grid x y : shape -> unit =
	let print_cell grid v =
		set_color grid.foreground;
		fill_rect
			(grid.bot.x + grid.width * (x+v.x))
			(grid.bot.y + grid.width * (y+v.y))
			(grid.width - grid.border-1)
			(grid.width - grid.border-1)
	in
		List.iter (print_cell grid)
;;

let rm_shape grid = print_shape {grid with foreground=grid.background};;



(** Shape recognition **)

let zeroize (shape:shape):shape =
	let minx, miny = ref max_int, ref max_int in
	let f r p = List.iter (fun v -> if p v < !r then r := p v) shape in
	f minx (fun v -> v.x);
	f miny (fun v -> v.y);
	let shape = List.map (fun f -> v (f.x - !minx) (f.y - !miny)) shape in
	let shape = List.sort compare shape in
	shape
;;

let tri v = {x = -v.y; y =  v.x}
and mid v = {x = -v.x; y = -v.y}
and hor v = {x =  v.y; y = -v.x}
and mir v = {x = -v.x; y =  v.y};;

let canonize : shape -> shape =
	let f h x = zeroize (List.map h x) in
	fun s -> let z = zeroize s in
		List.fold_left min z [f tri z; f mid z; f hor z];
;;

let canonize_sym : shape -> shape =
	let f h x = zeroize (List.map h x) in
	fun s -> let z = zeroize s and sz = zeroize (List.map mir s) in
		List.fold_left min z [f tri z; f mid z; f hor z; sz; f tri sz; f mid sz; f hor sz];
;;



(** Standard library **)

let pow=let rec f a x=function 0->a|n->if n mod 2=0then f a(x*x)(n/2)else f(a*x)x(n-1)in f 1;;

let dim mat = Array.length mat,Array.length mat.(0);;



(** Exploration **)

type evol = L | R | U | D;;

let next v dir = 
	let it be = be in let ax, ay = match dir with
		| L -> pred, it
		| R -> succ, it
		| U -> it, succ
		| D -> it, pred
	in
		{x=ax v.x; y=ay v.y}
;;

(* Calcul de tous les agencements de n carrés canonize-ment identiques *)
let explore_shapes canonize send n =
	let t = Hashtbl.create (pow 2 n)  in
	let rec explore s n =
		let c = canonize s in
		if not(Hashtbl.mem t c) then
			begin
				Hashtbl.add t c 1;
				if n = 1
					then send c
					else List.iter (fun dir -> List.iter (f s n dir) s) [R;U;L;D]
			end
	and f s n dir c =
		let v = next c dir in
		if not (List.mem v s) then
			explore (v::s) (n-1)
	in
		explore [v 0 0] n
;;
		


(** Using all that **)

let grid = {
	bot = {x=150; y=150};
	width = 20;
	border = 1;
	foreground = blue;
	background = yellow;
};;

let display =
	let r = ref 0 in
	fun s ->
		if !r mod 100 = 0 then begin
			clear_graph();
			print_shape grid 0 0 s
		end;
		incr r
;;

let n = ref 0;;

let send s =
	display s;
	incr n;
;;

let print_arrangements nb =
	open_graph " ";
	List.iter
		(fun i -> 
			n:=0;
			explore_shapes canonize send i;
			Printf.printf "%d cells -> %d shape%s\n%!" i !n (if !n>1 then "s" else "")
		)
		(let rec t a = function 0 -> a | n -> t (n::a) (pred n) in t [] nb)
	;
;;

print_arrangements 9;;









