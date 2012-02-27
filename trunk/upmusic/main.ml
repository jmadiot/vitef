open Printf

(* A [diff_content] is either a file or a list of files in a subdirectory or
   a whole subdirectory.
   One can obviously go from content to diff_content in two different ways:
   by lifting everything or erasing everyhting. *)

type content =
  | Dir of string * content list
  | File of string

type diff_content =
  | DDir of string * diff_content list
  | DFile of string
  | DWDir of string

let rec lift_content = function
  | File f -> DFile f
  | Dir (s , cs) -> DDir (s , List.map lift_content cs)

let diff_everything = function
  | File f -> DFile f
  | Dir (s, _) -> DWDir s

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

let rec check_equal cs ds = match cs, ds with
  | Dir (s, cs) , DDir (t, ds)
     when String.compare s t = 0 -> List.for_all2 check_equal cs ds
  | Dir (s, _) , DWDir t when String.compare s t = 0 -> true
  | File f , DFile g -> String.compare f g = 0
  | _ -> false

let rec sort = function
  | File _ as f -> f
  | Dir (name, cs) ->
    Dir (name, List.sort compare (List.map sort cs))

let normalize cs = List.sort compare (List.map sort cs)

(* Two directory's representations can be compared in order to generate
   a diff containing all the modifications done. [diff_list cs ds]
   consider that [cs] is the old listing and [ds] the new one and is
   used afterwards in [diff] that begins by sorting the content. *)

let check_whole name diff old =
  if List.for_all2 check_equal old diff
  then DWDir name
  else DDir (name, diff)

let concat_ifneq current result = match current with
  | DDir (_ , []) -> result
  | _ -> current :: result

let rec diff_list cs ds = match cs, ds with
  | [] , ds -> List.map diff_everything ds , []
  | cs , [] -> [] , List.map diff_everything cs
  | c :: cs , d :: ds -> match compare c d with
    | n when n < 0 ->
      let added , removed = diff_list cs (d :: ds) in
      added , (lift_content c) :: removed
    | n when n > 0 ->
      let added , removed = diff_list (c :: cs) ds in
      (lift_content d) :: added , removed
    | 0 ->
      begin
      match c, d with
      | Dir (name , es) , Dir (_ , fs) ->
        let added , removed = diff_list cs ds in
        let adesfs , rmesfs = diff_list es fs in
        let add = check_whole name adesfs fs in
        let rem = check_whole name rmesfs es in
        concat_ifneq add added , concat_ifneq rem removed
      | File _ , File _ -> diff_list cs ds
      | _ , _ -> assert false
      end
    | _ -> assert false

let diff cs ds = diff_list (normalize cs) (normalize ds)

(* From a diff, one can generate a set of actions to perform in order
   to sync the files. [list_of_files] outputs a pair containing in the first
   component the list of isolated files and in the second the list of whole
   directories to be diffed. *)

let rec list_of_files source files =
  List.fold_left (fun (ih1, ih2) file -> match file with
    | DFile name -> (sprintf "%s %s" (source^name) ih1 , ih2)
    | DDir (name , files) ->
      let f1 , f2 = list_of_files (source ^ name ^ "/") files in
      (f1 ^ " " ^ ih1 , f2 ^ " " ^ ih2)
    | DWDir name -> (ih1 , sprintf "%s %s" (source ^ name ^ "/") ih2))
  ("" , "") files

let commands added removed source =
  let (cps , cprs) = list_of_files source added in
  let (rms , rmrs) = list_of_files source removed in
  "cp -p " ^ cps , "cp -Rp " ^ cprs , "rm -f" ^ rms , "rm -Rf " ^ rmrs
