open Types
open Print

let _ =
  let (a, b, c) = Construct.construct_proposition 0 in
  print_proposition true (a, b, c)
