Require Import ZArith.
Open Scope Z_scope.

Inductive Collatz: Z -> Prop :=
| CollatzOne: Collatz 1
| CollatzEven: forall x, Collatz x -> Collatz (2*x)
| CollatzOdd: forall x, Collatz (3*x+2) -> Collatz (2*x+1).
