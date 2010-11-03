Require Import Definitions.
Let L:=Leaf.
Let N:=Node.
Let f ts:=match ts with
(L,L,L,L,L,L,N(N(N(N a b)c)d)e)=>N(N(N(N(N L a)b)c)d)e
|(L,L,L,L,L,L,t)=>t
|(L,L,L,L,L,a,b)=>N(N(N(N(N a b)L)L)L)L
|(L,L,L,L,N a b,c,d)=>N(N(N(N L d)c)a)b
|(a,b,c,d,e,f,g)=>N(N(N(N(N(N g f)e)d)c)b)a
end.
Let g t:=match t with
N(N(N(N(N(N a b)c)L)L)L)L=>(L,L,L,L,L,N a b,c)
|N(N(N(N(N(N a b)c)d)e)f)g=>(g,f,e,d,c,b,a)
|N(N(N(N(N L a)b)c)d)e=>(L,L,L,L,L,L,N(N(N(N a b)c)d)e)
|N(N(N(N L a)b)c)d=>(L,L,L,L,N c d,b,a)
|t=>(L,L,L,L,L,L,t)
end.
Let fg_id t:f(g t)=t.
destruct 0as[|[|[|[|[|[|??]?][|??]][|??]][|??]][|?]];auto.
Qed.
Let gf_id t:g(f t)=t.
destruct 0as[p h];destruct p as[p i];destruct p as[p e];destruct p as[p d];destruct p as[p c];destruct p as[a b];destruct a;destruct b;destruct c;destruct d;destruct e;destruct i;destruct h as[|[|[|[|]]]];auto.
Qed.