Require Import ZArith Definitions Omega.
Open Scope Z_scope.
Let perfect_square_dec n:0<=n->{perfect_square n}+{~perfect_square n}.
intros;case(Z_eq_dec n (Zsqrt_plain n*Zsqrt_plain n)).
left;rewrite e;constructor.
right;intro;destruct H0;destruct(Z_lt_dec 0 n);[|rewrite<-Zmult_opp_opp in*];rewrite Zsqrt_square_id in*;omega.
Qed.