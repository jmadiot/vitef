Require Import Definitions ZArith.
Open Scope Z_scope.
Let O p:Collatz(Zpos(3*p+2))->Collatz(Zpos(p~1)) := CollatzOdd(Zpos p).
Let E p:Collatz(Zpos p)->Collatz(Zpos(p~0)) := CollatzEven(Zpos p).
Ltac C:=try constructor||apply E||apply O.
Ltac c:=intuition;repeat(vm_compute;C).
Lemma B p:p=xH\/exists q,p=Psucc q.
intros;destruct(Psucc_pred p);eauto.
Qed.
Lemma pde p n P:(Zpos p<=n-1->P)->(Zpos(Psucc p)<=n->P).
c;rewrite Zpos_succ_morphism in*;c.
Qed.
Theorem Collatz_1000 x:1<=x<=1000->Collatz x.
intros?[P Q];destruct x;try(elimtype False;try pose proof(Zlt_neg_0 p);omega).
clear P;revert p Q.
do 1000(intro p; destruct(B p)as[|[p' Hp']];[subst;c|];C; rewrite Hp'; clear Hp' p; apply pde; revert p'; simpl Zminus in*).
intros;elimtype False;pose proof Zgt_pos_0;auto.
Qed.