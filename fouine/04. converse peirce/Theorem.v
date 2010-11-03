Require Import Definitions.
Let Excluded_Middle P:P\/~P.
intro;apply(Peirce _ False);auto.
Qed.