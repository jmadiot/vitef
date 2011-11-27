open Printf

(** In the following comment we note [xs --> ys] the permutation mapping
    the ith element of [xs] to the ith element of [ys].
    For example [[2; 1] --> [1;2]] is the permutation that sorts [[2; 1]]. **)

(** [has_fixpoint xs ys] checks whether the permutation [xs --> ys]
    has a fixpoint. (i.e. exists i. xs(i) = ys(i)). **)

let rec has_fixpoint xs ys = match xs, ys with
  | [], [] -> false
  | x :: _ , y :: _ when x = y -> true
  | _ :: xs, _ :: ys -> has_fixpoint xs ys
  | _ , _ -> assert false

(** [pop_nth i xs] returns the [i]th element of [xs] together with [xs] minus
    this element. **)

let rec pop_nth i xs = match i, xs with
  | 0, x :: xs -> x, xs
  | n, x :: xs ->
    let (y, ys) = pop_nth (n - 1) xs in
    (y, x :: ys)
  | _, _ -> assert false

(** [permutation_list xs] outputs a permutation of [xs] choosing one element
    after the other.
    [fp_free_permutation_list xs] generates a fixpoint-free permutation of [xs]
    by producing permutation until one of them is ok. **)

let permutation_list xs =
  let rec permutation_acc bound stack acc = match bound with
    | 0 -> (List.hd stack) :: acc
    | n ->
      let (y, ys) = pop_nth (Random.int (n + 1)) stack in
      permutation_acc (n - 1) ys (y :: acc)
  in permutation_acc (List.length xs - 1) xs []

let rec fp_free_permutation_list xs =
  let pl = permutation_list xs in
  if has_fixpoint pl xs
  then fp_free_permutation_list xs
  else pl

(** [image xs ys x] outputs the image of [x] by the permutation [xs --> ys]. *)

let rec image xs ys i = match xs, ys with
  | x :: _, y :: _ when x = i -> y
  | _ :: xs, _ :: ys -> image xs ys i
  | _, _ -> assert false

let secret_santa people =
  let assoc = fp_free_permutation_list people in
  image people assoc

(** And now the command-line interface. **)

(** Reading the name of the people from a file. **)

let get_people filepath =
  let chan = open_in filepath in
  let rec get_acc acc =
    try get_acc (input_line chan :: acc)
    with _ -> close_in chan; acc
  in
  get_acc []

(** **)

let target_file = ref None
let target_name = ref None
let seed = ref 12

let usage () = print_string "[ usage: santa [-s seed] -n name file ]\n"

let rec parse = function
  | "-s" :: n :: ll -> seed := int_of_string n; parse ll
  | "-n" :: name :: ll -> target_name := Some name; parse ll
  | f :: ll -> target_file := Some f; parse ll
  | [] -> ()


let main () =
  let () = parse (List.tl (Array.to_list Sys.argv)) in
  match !target_file, !target_name with
    | None, _ | _, None -> usage ()
    | Some filepath, Some name ->
      if Sys.file_exists filepath
      then
        let people = get_people filepath in
        let () = Random.init !seed in
        let target = secret_santa people name in
        printf "You are supposed to get a gift to: %s\n" target
      else printf "*** Error: file %s does not exist!\n" filepath

let () = main ()
