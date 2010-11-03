Require Import ZArith.
Let sqrt_2 n m:n*n=2*m*m->m=0.
intros;destruct m;[easy|];destruct n;[simpl in H; congruence|];rewrite<-nat_of_P_o_P_of_succ_nat_eq_succ;do 4 rewrite<-nat_of_P_o_P_of_succ_nat_eq_succ in*;do 3 rewrite<-nat_of_P_mult_morphism in*;apply nat_of_P_inj in H;elimtype False;simpl in*;remember(P_of_succ_nat n);remember(P_of_succ_nat m)as b;clear n m Heqp Heqb;revert p b H;induction p;intros;simpl in H;try congruence;rewrite Pmult_comm in H;simpl in*;induction b;simpl in H;try congruence;rewrite (Pmult_comm b) in H;simpl in*;apply(IHp b);injection H;easy.
Qed.