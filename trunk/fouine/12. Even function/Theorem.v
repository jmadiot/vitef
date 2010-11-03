Require Import Definitions ZArith Utf8.
Let even_pos A f(P:A->Prop):even_function f->(∀x,Zge x 0->P(f x))->∀x,P(f x).
intros;case(Zle_or_lt 0x);[|rewrite H];intuition.
Qed.