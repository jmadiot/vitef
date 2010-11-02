Require Import Definitions List.
Ltac i:=intuition.
Let tails {A:Set}(y:list A):{x|all_suffixes x y}.
intros;induction y.
exists(nil::nil);split;destruct 1;[apply app_eq_nil in H;left|exists nil|];i.
destruct IHy.
exists((a::y)::x);split;destruct 1.
destruct x0.
left;i.
right;eapply a0;exists x0;inversion H;i.
destruct H;exists nil;i.
apply a0 in H;inversion H;subst.
exists(a::x0).
eapply app_comm_cons.
Qed.