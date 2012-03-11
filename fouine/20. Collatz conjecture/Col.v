Require Import Definitions ZArith.
Open Scope Z_scope.
Let K:=Collatz.
Let O p:K(Zpos(3*p+2))->K(Zpos(p~1)):=CollatzOdd(Zpos p).
Let E p:K(Zpos p)->K(Zpos(p~0)):=CollatzEven(Zpos p).
Ltac c:=repeat(compute;eauto;constructor||apply E||apply O).
Ltac M n:=match eval compute in n with 100
=>idtac|_=>let N:=constr:(Zsucc n)in assert(K N)by c;simpl Zsucc in*;M N
end.
Let Collatz_1000 x:1<=x<=100->K x.
M 0;intros p(U,V);do 11(destruct p;vm_compute in U,V;try congruence).
Qed.