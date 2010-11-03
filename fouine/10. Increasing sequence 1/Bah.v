Require Import Definitions Omega.
Ltac o:=intuition (try omega;eauto).
Let LPO_ICD:LPO->ICD.
do 3intro;case(X(fun n=>exists m,x n<x m));o.
case(X(fun m=>x m<=x n));o.
case(le_lt_dec(x n0)(x n));[left|right];o.
elim s;left;exists x0;o.
right;intros[m Hm];specialize(l m);o.
left;destruct s as[n];exists n;intros.
specialize(H _ _ H0);destruct(le_lt_dec(x m)(x n));o;elim f;o.
Qed.