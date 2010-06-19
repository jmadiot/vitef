(* #load "graphics.cma" interpreter *)
open Graphics

let () = Random.self_init ()

type transition = DIE | BORN | STAY

let mysleep n =
  for i = 0 to n do () done

let transition2 grid i j g_m g_n =
 let rec aux_i accu = function
  | -2 -> accu
  | m -> aux_i (aux_j 0 m 1 + accu) (m-1)
 and aux_j accu m = function
  | -2 -> accu
  | n -> if (m <> 0 || n <> 0) && i + m >= 0 && i + m < g_m && j + n >= 0 && j + n < g_n
        then aux_j (accu + grid.(i+m).(j+n)) m (n-1)
        else aux_j accu m (n-1)
 in
  let compteur = aux_i 0 1 in
 if compteur <= 4 then BORN
 else DIE

let transition grid i j g_m g_n =
 let rec aux_i accu = function
  | -2 -> accu
  | m -> aux_i (aux_j 0 m 1 + accu) (m-1)
 and aux_j accu m = function
  | -2 -> accu
  | n -> if (m <> 0 || n <> 0) && i + m >= 0 && i + m < g_m && j + n >= 0 && j + n < g_n
        then aux_j (accu + grid.(i+m).(j+n)) m (n-1)
        else aux_j accu m (n-1)
 in
  let compteur = aux_i 0 1 in
 if compteur == 3 then BORN
 else if compteur == 2 then STAY
 else DIE

let update grid proba =
 let m = Array.length grid in
 let n = Array.length (grid.(0)) in
 let new_grid = Array.make m [||] in
 for i = 0 to m - 1 do
  new_grid.(i) <- Array.make n 0;
  for j = 0 to n - 1 do
   if Random.int 100 < proba then
    match transition grid i j m n with
      | DIE -> new_grid.(i).(j) <- 0
      | BORN -> new_grid.(i).(j) <- 1
      | STAY -> new_grid.(i).(j) <- grid.(i).(j)
   else new_grid.(i).(j) <- grid.(i).(j)
  done;
 done;
new_grid

let console_print grid =
 let m = Array.length grid - 1 in
 let n = Array.length (grid.(0)) - 1 in
 for i = 0 to m do
  for j = 0 to n do
   match grid.(i).(j) with
   | 0 -> print_string " ";
   | _ -> print_string "X";
  done;
  print_string "\n";
 done

let print = let i = ref (-1) in
 function grid ->
begin
 i := !i + 1;
 if !i mod 10 = 0 then
 let m = Array.length grid in
 let n = Array.length (grid.(0)) in
 begin
  Graphics.open_graph "";
  let () = auto_synchronize false in
  Graphics.resize_window (2*n+2) (2*m+2);
  Graphics.set_window_title "Jeu de la vie";
  Graphics.set_color Graphics.red;
  Graphics.moveto 0 0;
  Graphics.lineto (2*n+1) 0;
  Graphics.lineto (2*n+1) (2*m+1);
  Graphics.lineto 0 (2*m+1);
  Graphics.lineto 0 0;
  let image = Array.make (2*m) [||] in
  for i = 0 to 2*m - 1 do
    image.(i) <- Array.make (2*n) 0;
  done;
  for i = 0 to m - 1 do
   for j = 0 to n - 1 do
    let color = (if grid.(i).(j) = 1 then Graphics.white else Graphics.black) in
     image.(2*i).(2*j) <- color;
     image.(2*i+1).(2*j) <- color;
     image.(2*i).(2*j+1) <- color;
     image.(2*i+1).(2*j+1) <- color;
    done;
  done;
  Graphics.draw_image (Graphics.make_image image) 1 1;
 end
 else ()
end

let create m n p =
 let new_grid = Array.make m [||] in
 for i = 0 to m - 1 do
  new_grid.(i) <- Array.make n 0;
  for j = 0 to n - 1 do
   if Random.int p = 0
    then new_grid.(i).(j) <- 1;
  done;
 done;
new_grid

let test proba =
 let rec itere grid = function
  | 0 -> let new_grid = update grid proba in print new_grid; let () = synchronize () in let _ = wait_next_event [] in ();
  | n -> let new_grid = update grid proba in print new_grid; let () = synchronize () in itere new_grid (n-1)
 in
 itere (create 300 500 10) 1000

let () = test 20
