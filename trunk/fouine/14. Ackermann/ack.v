Let Ackermann_Function_Exists:exists f,forall m n,f 0n=S n/\f(S m)0=f m 1/\f(S m)(S n)=f m(f(S m)n).
exists(nat_rec _ S(fun b(x:_->_)=>nat_rec _(x 1)(fun c=>x)));auto.
Qed.