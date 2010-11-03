Require Import Lists.List.

Fixpoint sum (xs: list nat) : nat :=
  match xs with
    | nil => 0
    | x :: xs => x + sum xs
  end.
