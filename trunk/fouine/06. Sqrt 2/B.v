Require Import ZArith.
Ltac c:=(simpl in*;try congruence)with w x:=rewrite(Pmult_comm x)in*;c.
Let sqrt_2 n m:n*n=2*m*m->m=0.
intros;destruct m;auto;destruct n.
c.
set nat_of_P_o_P_of_succ_nat_eq_succ;rewrite<-e;do 7(rewrite<-e in*||rewrite<-nat_of_P_mult_morphism in*);apply nat_of_P_inj in H;elimtype False;c;remember(P_of_succ_nat n);remember(P_of_succ_nat m)as b;clear-H;revert p b H;induction p;intros;c;w p;induction b;c;w b.
Qed.