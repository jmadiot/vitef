Require Import Definitions Arith Omega.
Theorem LPO_ICD: LPO -> ICD.
cbv delta;fold not;intros.
destruct (X (fun n => exists m : _, x n < x m));auto.
 intros.
 destruct (X (fun m => ~ x n < x m)).
  intro;case (le_lt_dec (x n0) (x n));[left|right];omega.
  left;destruct s; exists x0; omega.
  
  right;intro.
  elim H0.
  intros.
  case (n0 x0).
  auto.
  
 destruct s.
 left.
 exists x0.
 intros.
 destruct (eq_nat_dec (x x0) (x m)).
  auto.
  
  apply False_ind.
  apply n.
  exists m.
  assert (x x0 <= x m);auto;omega.
Qed.