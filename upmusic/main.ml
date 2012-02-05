type content =
  | Dir of string * content list
  | File of string

(* [compare cs ds] compares two elements of the same directory. A file
   is always smaller than a directory and two files (or directories)
   cannot have the same name.
   This comparison function is reused to write [sort cs] which finds a
   normal form for the representation of the content [cs]. *)

let compare cs ds = match cs, ds with
  | Dir (s, _) , Dir (t, _) -> String.compare s t
  | File f , File g -> String.compare f g
  | Dir _ , File _ -> +1
  | File _ , Dir _ -> -1

let rec sort = function
  | File _ as f -> f
  | Dir (name, cs) ->
    Dir (name, List.sort compare (List.map sort cs))

let normalize cs = List.sort compare (List.map sort cs)

(* Two directory's representations can be compared in order to generate
   a diff containing all the modifications done. [diff_list cs ds]
   consider that [cs] is the old listing and [ds] the new one and is
   used afterwards in [diff] that begins by sorting the content. *)

let concat_ifneq name es result = match es with
  | [] -> result
  | _ -> Dir (name, es) :: result

let rec diff_list cs ds = match cs, ds with
  | [] , ds -> ds , []
  | cs , [] -> [] , cs
  | c :: cs , d :: ds ->
    match compare c d with
    | n when n < 0 ->
      let added , removed = diff_list cs (d :: ds) in
      added , c :: removed
    | n when n > 0 ->
      let added , removed = diff_list (c :: cs) ds in
      d :: added , removed
    | 0 -> match c, d with
      | Dir (name , es) , Dir (_ , fs) ->
        let adesfs , rmesfs = diff_list es fs in
        let added , removed = diff_list cs ds in
        concat_ifneq name adesfs added , concat_ifneq name rmesfs removed
      | File _ , File _ -> diff_list cs ds
      | _ , _ -> assert false

let diff cs ds = diff_list (normalize cs) (normalize ds)
