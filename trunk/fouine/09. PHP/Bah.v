Require Import Definitions List Omega.
Let Pigeon_Hole_Principle l:length l<sum l->exists x,1<x/\In x l.
induction 0;simpl;intro.
inversion H.
destruct(dec_lt 1a).
exists a;tauto.
destruct IHl;omega||exists x;tauto.
Qed.