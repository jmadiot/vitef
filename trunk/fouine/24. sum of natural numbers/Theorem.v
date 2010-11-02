Require Import Definitions.
Require Import Arith.
Let Sum_of_nat n:2*sum n=n*(n+1).
induction n;auto.
unfold sum in*.
rewrite mult_plus_distr_l,IHn;ring.
Qed.