Require Import Definitions Omega.
Section C.
Variables(P:nat->Prop)(d:forall n,decidable(P n)).
Fixpoint D n:bool:=match n with
0=>true|S m=>if d m then D m else false end.
Fixpoint s n:=match n with
0 => 0|S m=>if D(S m)then S(s m) else s m end.
Ltac a:=eauto.
Definition M m k:D m=false->D(k+m)=false/\s m=s(k+m).
intros;induction k;simpl;a.
destruct IHk;rewrite H1,H0;case(d(k+m));a.
Qed.
End C.
Ltac eo:=elimtype False;omega.
Let ICD_LPO:ICD->LPO.
intros A B C.
(*intros icd P dec.*)
  assert (inc: increasing (s P C)).
  red. induction 1. auto.
  apply le_trans with (1:=IHle).
  simpl. case (dec m); auto. case (D P dec m); auto.
  destruct (icd _ inc).
  left.
  destruct c as [n Hn].
  induction n.
  exists 0.
  specialize (Hn _ (le_n_Sn _)).
  simpl in Hn.
  destruct (dec 0). discriminate. auto.
  case_eq (D P dec n); intros.
  specialize (Hn _ (le_n_Sn _)).
  simpl in Hn.
  rewrite H in Hn.
  destruct (dec n); eauto.
  destruct (dec (S n)); eauto; eo.
  apply IHn; intros.
  destruct H0. auto.
  rewrite <- (Hn (S m)) by omega.
  simpl.
  rewrite H.
  case (dec n); auto.
  right; intros.
  destruct (d n) as [m Hm].
  destruct (le_lt_dec m n).
  specialize (inc _ _ l); eo.
  case_eq (dec n); intros. destruct (dec n); auto.
  destruct (M P dec (S n) (m-S n)).
  simpl.
  rewrite H; auto.
  simpl in H1.
  rewrite H in H1.
  replace (m-S n+S n) with m in H1 by omega; eo.
Qed.